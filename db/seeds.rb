student = Student.create!(email: "islamodeh@hotmail.com",
                          full_name: "test_std",
                          password: "islamodeh@hotmail.com")

instructor = Instructor.create!(email: "islamodeh@hotmail.com",
                                full_name: "test_inst.",
                                password: "islamodeh@hotmail.com")


course = instructor.courses.create!(name: "Network Forensics",
                                    section: 1,
                                    description: "This course covers computer security and network forensics, forensic duplication and analysis, network surveillance, intrusion detection and prevention, incident response and trace-back. Signature and anomaly based intrusion detection, Pattern matching algorithms, Viruses, Trojans and worms detection. Multicast Fingerprinting, Anonymity and Pseudonym.")

work = course.works.create!(work_type: "assignment", description: "GG WP")

work.samples.create!(input: "1 2", output: "3")

student.enrollments.create(course_id: course.id, status: "accepted")

student.submissions.create!(grade: 100,
                            status: "accepted",
                            work_id: work.id,
                            code: "print 'test'",
                            language: "python")