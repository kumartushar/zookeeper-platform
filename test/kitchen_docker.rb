# Thanks to:
# https://medium.com/brigade-engineering/reduce-chef-infrastructure-integration-test-times-by-75-with-test-kitchen-and-docker-bf638ab95a0a
require 'kitchen/driver/docker'

module Kitchen
  module Driver
    class Docker < Kitchen::Driver::SSHBase

      def login_command(state)
        LoginCommand.new(
          "docker exec -it #{state[:container_id]} bash -c 'TERM=xterm bash'",
          [])
      end

      def rm_container(state)
        container_id = state[:container_id]
        docker_command("exec #{container_id} shutdown now")
        docker_command("wait #{container_id}") # Wait for shutdown
        docker_command("rm #{container_id}")
      end

    end
  end
end
