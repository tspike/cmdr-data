job_type :job,  "cd :path && bundle exec tasks/:task.rb"

every 2.hours do
  job "fetch_colorado_reports"
end
