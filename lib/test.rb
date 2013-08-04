require 'rack'
class Test
  def self.call(env)
    [200, {'Content-Type' => 'text/html'}, ['foo-bar']]
  end
end