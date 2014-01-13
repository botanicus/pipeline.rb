require 'nake'

Nake::Task.new(:queues) do |task|
  task.define do
    Pipeline::Plugin.plugins.each do |plugin|
      puts "#{plugin}: #{plugin::QUEUES.inspect rescue []}"
    end
  end
end


Nake::Task.new(:declare) do |task|
  task.define do
    abort "Still on the TODO list.\nFor now, just run all the consumers and everything gets declared at runtime."
  end
end
