$APP_ROOT = '/home/ubuntu/apps/uat_stockability/current'

God.watch do |god|
  god.log  = '/home/ubuntu/apps/uat_stockability/shared/log/god.log'
  god.name = 'uat_stockability'
  
  god.start   = "cd #{$APP_ROOT} && sh config/unicorn_init.sh start"
  god.restart = "cd #{$APP_ROOT} && sh config/unicorn_init.sh restart"
  god.stop    = "cd #{$APP_ROOT} && sh config/unicorn_init.sh stop"

  god.interval = 5.seconds

  god.start_if do |start|
    start.condition(:process_running) do |c|
      c.running = false
    end
  end

  god.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 20.percent
      c.times = [3, 5] # 3 out of 5 intervals
    end

    restart.condition(:cpu_usage) do |c|
      c.above = 50.percent
      c.times = 5
    end
  end
end