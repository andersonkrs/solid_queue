# frozen_string_literal: true

module SolidQueue
  class Execution
    module Dispatching
      extend ActiveSupport::Concern

      class_methods do
        def dispatch_jobs(job_ids)
          jobs = Job.where(id: job_ids)

          Job.dispatch_all(jobs).map(&:id).then do |dispatched_job_ids|
            if dispatched_job_ids.none? then 0
            else
              where(job_id: dispatched_job_ids).order(:job_id).delete_all
            end
          end
        end
      end
    end
  end
end