module CloudLbService
  module Clb
    # It's stupid to be using rumm here, I should just use fog directly..
    class Helper
      def shell_execute(command)
        `#{command}`
      end

      def get_nodes(load_balancer)
        retval = []
        nodes_output = shell_execute("rumm show nodes on loadbalancer \"#{load_balancer}\"")
        node_lines = nodes_output.split("\n")
        node_lines.shift
        node_lines.each do |line|
          node_hash = {}
          line.split(',').each do |pair|
            parts = pair.split(':')
            node_hash[parts.first.strip] = parts.last.strip
          end
          retval << node_hash
        end
        retval
      end

      def node_id_from_ip(load_balancer, ip)
        nodes = self.get_nodes(load_balancer)
        matched_nodes = nodes.select {|n| n['address'] == ip}
        matched_nodes.length == 0 ? nil : matched_nodes.first['id']
      end

      def add_node(load_balancer, listen_ip, listen_port)
        command = "rumm create node on loadbalancer \"#{load_balancer}\" " +
            "--address \"#{listen_ip}\" --port #{listen_port}"
        shell_execute(command)
      end

      def detach_node(load_balancer, node)
        command = "rumm destroy node #{node} on loadbalancer \"#{load_balancer}\""
        shell_execute(command)
      end
    end
  end
end