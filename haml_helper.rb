module HamlHelper
	def self.render(partial, locals = {})
	  Haml::Engine.new(File.read("./public/haml/#{partial}.haml")).render(Object.new, locals)
	end
end