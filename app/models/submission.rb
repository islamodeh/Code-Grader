class Submission < ApplicationRecord
  STATUSES = ["Pending",
              "Fatal Error",
              "Compilation Failed",
              "Running",
              "Finished",
              "Timed out",
              "Memory limit exceeded",
              "Cheated"].freeze

  C_EX = "#include <stdio.h>
  int main(void) {
    // your code goes here
    return 0;
  }".freeze

  LANGUAGES_MAP = { "c" => { extension: ".c", docker_image_tag: "c_vm", compiler: "gcc" },
                    "c++" => { extension: ".cpp", docker_image_tag: "c_vm", compiler: "g++" },
                  }.freeze

  belongs_to :userable, polymorphic: true
  belongs_to :work
  has_many :cheat_logs, dependent: :destroy

  validates :code, :language, :status, presence: :true
  validates :status, inclusion: { in: STATUSES }
  validates :language, inclusion: { in: LANGUAGES_MAP.keys }
  validate -> { errors.add(:submission, "is closed!") if !work.can_submit? && userable_type != "Instructor" }

  before_destroy -> { CheatLog.where(cheated_from_submission_id: id).destroy_all }

  def get_grade(solved)
    samples = work.samples
    samples.count.zero? ? 0 : ((solved.to_f / samples.count) * 100).ceil
  end

  def cheating?
    cheat_flag = false
    dir_name = "#{userable_type.to_s.downcase}_self.userable_id_#{SecureRandom.urlsafe_base64}"
    dir_path = File.join(Rails.root, "tmp", dir_name)

    begin
      Dir.mkdir(dir_path)
      File.open("#{dir_path}/current_submission.txt", "wb") do |file|
        file.write(code)
      end

      other_students_submissions = Submission.where(work_id: work_id,
                                                    language: language,
                                                    userable_type: "Student")
                                             .where.not(userable: userable, status: "Cheated").includes(:userable)

      other_students_submissions.each do |submission|
        File.open("#{dir_path}/user_id?#{submission.userable.id},submission_id?#{submission.id}.txt", "wb") do |file|
          file.write(submission.code)
        end
      end

      results = `./sherlock -e ".txt" -z 0 #{dir_path}`.gsub("#{dir_path}/", "").gsub(";", " ")
      results = results.split("\n").map { |line| line if line.include?("current_submission") }.compact
      results.each do |result|
        result = result.split(" ")
        result.delete("current_submission.txt")
        cheat_percentage = result[1].gsub("%", "").to_i
        info =  result[0].gsub(".txt", "").split(",")
        cheated_from_submission_id = (info[1].split("?")[1]).to_i
        cheat_log = CheatLog.new(submission_id: id,
                                 cheated_from_submission_id: cheated_from_submission_id,
                                 cheat_percentage: cheat_percentage)
        cheat_log.save
        if cheat_percentage >= 20
          cheat_flag = true
        end
      end
    ensure
      FileUtils.remove_dir(dir_path, true)
    end

    cheat_flag
  end

  def docker_image!
    Docker::Image.get(docker_image_tag)
  end

  def create_container!
    Docker::Container.create({ 'Image' => docker_image!.id, 'tty' => true, name: "submission_#{id}" })
  end

  def docker_image_tag
    LANGUAGES_MAP[language].try(:[], :docker_image_tag)
  end

  def extension
    LANGUAGES_MAP[language].try(:[], :extension)
  end

  def compiler
    LANGUAGES_MAP[language].try(:[], :compiler)
  end
end
