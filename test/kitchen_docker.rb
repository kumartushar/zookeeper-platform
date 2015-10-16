#
# Copyright (c) 2015 Sam4Mobile
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Monkey patch kitchen-docker:
# - use docker login instead of ssh
# - improve destroy time when systemd is used inside docker
#
# Special thanks to Shane da Silva for:
# https://medium.com/brigade-engineering/\
#       reduce-chef-infrastructure-integration-test-times-by-75\
#       -with-test-kitchen-and-docker-bf638ab95a0a

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
        # Fix for slow destroy, systemctl half -f does not solve the problem
        # If you have a better way, you're welcome
        docker_command(<<-eos)
        exec #{container_id} bash -c \
          'systemctl list-units | grep running | grep -v systemd | \
          cut -d\" \" -f1 | xargs systemctl -s9 kill 2> /dev/null & \
          systemctl halt'
        eos
        docker_command("wait #{container_id}") # Wait for shutdown
        docker_command("rm #{container_id}")
      end

    end
  end
end
