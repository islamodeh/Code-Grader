class Instructor::SamplesController < Instructor::InstructorsController
  def index
    @course = current_instructor.courses.find_by(id: params[:course_id])
    @work = @course.works.find_by(id: params[:work_id])
    @samples = @work.samples
  end

  def new
    course = current_instructor.courses.find_by(id: params[:course_id])
    work = course.works.find_by(id: params[:work_id])
    @sample = work.samples.new
  end

  def create
    course = current_instructor.courses.find_by(id: params[:course_id])
    work = course.works.find_by(id: params[:work_id])
    @sample = work.samples.new(sample_params_require)

    if @sample.save
      flash[:success] = "Sample created!"
      redirect_to(instructor_course_work_samples_path(course.id, work.id))
    else
      flash[:danger] = @sample.errors.full_messages.join(", ")
      render :new
    end
  end

  def update
    course = current_instructor.courses.find_by(id: params[:course_id])
    work = course.works.find_by(id: params[:work_id])
    @sample = work.samples.find_by(id: params[:id])

    if @sample.update(sample_params_require)
      flash[:success] = "Sample updated!"
    else
      flash[:danger] = @sample.errors.full_messages.join(", ")
    end

    redirect_to(instructor_course_work_samples_path(course.id, work.id))
  end

  def destroy
    course = current_instructor.courses.find_by(id: params[:course_id])
    work = course.works.find_by(id: params[:work_id])
    sample = work.samples.find_by(id: params[:id])

    if sample.destroy
      flash[:success] = "Sample deleted!"
    else
      flash[:danger] = sample.errors.full_messages
    end

    redirect_to(instructor_course_work_samples_path(course.id, work.id))
  end

  def sample_params_require
    params.require(:sample).permit(:input, :output)
  end
end
