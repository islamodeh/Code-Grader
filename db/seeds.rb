student = Student.new(email: "islamodeh@hotmail.com",
                      full_name: "code-grader-student",
                      password: "code-grader-student")
student.save(validate: false)
student.update_column(:confirmed_at, DateTime.now)

instructor = Instructor.new(email: "islamodeh@hotmail.com",
                            full_name: "code-grader-insturctor",
                            password: "code-grader-insturctor")
instructor.save(validate: false)
instructor.update_column(:confirmed_at ,DateTime.now)

course = instructor.courses.create!(name: "Network Forensics",
                                    section: 1,
                                    description: "This course covers computer security and network forensics, forensic duplication and analysis, network surveillance, intrusion detection and prevention, incident response and trace-back. Signature and anomaly based intrusion detection, Pattern matching algorithms, Viruses, Trojans and worms detection. Multicast Fingerprinting, Anonymity and Pseudonym.")

work = course.works.create!(
  name: "1st" , work_type: "Assignment", description: "First Assignment",
  start_date: DateTime.now, end_date: DateTime.now + 1.month, zone_name: "Asia/Amman"
  )

work.samples.create!(input: "1 2", output: "3")

student.enrollments.create(course_id: course.id, status: "Accepted")