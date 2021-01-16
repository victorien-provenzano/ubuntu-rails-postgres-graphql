Datadog.configure do |c|
  # This will activate auto-instrumentation for Rails
  c.use :rails
  c.env = 'test'
  c.tags = { 'team' => 'cake' }
  c.version = '3.0.0'
end