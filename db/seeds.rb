student = Student.create!(email: "2014000@std.psut.edu.jo",
                          full_name: "test_std",
                          password: "123456")

instructor = Instructor.create!(email: "test.doctor@psut.edu.jo",
                                full_name: "test_inst.",
                                password: "123456")

course = instructor.courses.create!(name: "Penetration Testing",
                                    section: 1,
                                    description: "hacking 101")

work = course.works.create!(work_type: "assigment", description: "GG WP")

work.samples.create!(input: "1 2", output: "3")

student.enrollments.create(course_id: course.id, status: "accepted")

student.submissions.create!(grade: 100,
                            status: "accepted",
                            work_id: work.id,
                            code: "print 'test'",
                            language: "python")