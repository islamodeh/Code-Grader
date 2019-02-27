class Submission < ApplicationRecord
  STATUSES = ["Pending",
              "Compilation Failed",
              "Running",
              "Finished",
              "Timed out",
              "Memory limit exceeded"
              ]
  LANGUAGES = %w(C C++)
  C_EX = "#include <stdio.h>
  int main(void) {
    // your code goes here
    return 0;
  }"
  belongs_to :userable, polymorphic: true
  belongs_to :work
  
  validates :code, :language, :status, presence: :true
  validates :status, inclusion: { in: STATUSES }
  validates :language, inclusion: { in: LANGUAGES }

  validate lambda { errors.add(:submission, "is closed!") if (!self.work.can_submit? && self.userable_type != "Instructor")}
  validate lambda { errors.add(:cheating, "is not a good idea ...") if (self.userable_type == "Student" && cheating?) }

  def get_grade(solved)
    samples = self.work.samples
    samples.count == 0 ? 0 : (( (solved.to_f / samples.count) * 100).ceil)
  end

  def cheating?
    cheat_flag = false
    dir_name = "#{self.userable_type.to_s.downcase}_self.userable_id_#{SecureRandom.urlsafe_base64}"
    dir_path = File.join(Rails.root, 'tmp', dir_name)

    begin
      Dir.mkdir(dir_path)
      File.open("#{dir_path}/current_submission.txt", 'wb') do |file|
        file.write(self.code)
      end

      other_students_submissions = Submission.where(work_id: self.work_id, language: self.language, userable_type: "Student").where.not(userable: self.userable).includes(:userable)

      other_students_submissions.each do |submission|
        File.open("#{dir_path}/#{submission.userable.email}_submission_id_#{submission.id}.txt", 'wb') do |file|
          file.write(submission.code)
        end
      end
      results = `./sherlock -e ".txt" -z 0 #{dir_path}`.gsub("#{dir_path}/","").gsub(";"," ")
      results = results.split("\n").map{ |line| line if line.include?("current_submission") }.compact

      results.each do |result|
        percentage = result.split(" ")[2].gsub("%", "").to_i
        if percentage >= 20
          cheat_flag = true
          break
        end
      end
    ensure
      FileUtils.remove_dir(dir_path, true)
    end

    cheat_flag
  end
end
