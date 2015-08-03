class Dock < Thor
  PROJECT     = "strife"
  DOCKER_USER = "jdabbs"
  DEV         = "dev"
  PROD        = "sarah"

  desc "up", "Build and start app on development docker machine"
  def up
    env DEV
    run "docker-compose build"
    run "docker-compose up"
  end

  desc "deploy", "Build, push, and restart app on production docker machine"
  def deploy
    env DEV
    run "docker-compose build"
    run "docker tag -f #{PROJECT}_web #{DOCKER_USER}/#{PROJECT}_web"
    run "docker push #{DOCKER_USER}/#{PROJECT}_web"

    env PROD
    run "docker-compose -f docker/prod.yml stop web"
    run "docker-compose -f docker/prod.yml pull"
    run "docker-compose -f docker/prod.yml rm -f web"
    run "docker-compose -f docker/prod.yml scale web=1"
  end

private

  def env name
    @env = name
  end

  def run cmd
    print set_color "(", :blue, :bold
    print @env
    print set_color ")==> ", :blue, :bold
    puts cmd

    unless system(%{eval "$(docker-machine env #{@env})" && #{cmd}})
      raise "Command failed: #{cmd}"
    end
    puts
  end
end
