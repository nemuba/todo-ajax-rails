Shog.configure do
  if ::Rails.env.production?
    reset_config!
    timestamp
  end

  match /execution expired/ do |msg,matches|
    # Highlight timeout errors
    msg.red
  end

  severity_tag :info, ->(msg) { msg.strip.green }
  severity_tag :debug, ->(msg) { msg.strip.blue }
  severity_tag :warn, ->(msg) { msg.strip.yellow }
  severity_tag :error, ->(msg) { msg.strip.red }
  severity_tag :fatal, ->(msg) { msg.strip.red.bold }
end
