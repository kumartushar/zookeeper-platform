require 'kitchen/command'

module Kitchen
  module Command

    module RunAction
      alias_method :run_action_official, :run_action

      def run_action(action, instances, *args)
        # Extract dnsdock instance(s) to be able to launch it first
        # so it is ready for other containers
        dnsdocks = instances.select {|i| i.suite.name.include? "dnsdock" }
        services = instances - dnsdocks

        case action
        when :destroy
          run_action_official(action, instances, *args)
        when :test
          run_action_official(:destroy, instances)
          run_action_official(:create, dnsdocks)
          run_action_official(:create, services)
          run_action_official(:converge, instances)
          run_action_official(:verify, instances)
          run_action_official(:destroy, instances) if args.first == :passing
        else
          # Always run create first to initiaze all dockers
          run_action_official(:create, dnsdocks)
          run_action_official(:create, services)
          run_action_official(:converge, instances) if action == :verify
          run_action_official(action, instances, *args) if action != :create
        end
      end

    end

  end
end
