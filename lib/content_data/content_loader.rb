module ContentLoader
  CONST_NAME = 'Contents'
  class << self
		def load!
      contents = load_files(Dir["#{Rails.root}/config/content_data/**/*.yml"].sort.uniq)
      Kernel.send(:remove_const, CONST_NAME) if Kernel.const_defined?(CONST_NAME)
      ::Kernel.const_set(CONST_NAME, contents)
		end
		
		def load_files(files)
			{}.tap do |contents|
				files.each do |yaml|
					key = yaml.gsub("#{Rails.root}/config/content_data", '').gsub('.yml', '')
					contents[key] = YAML.load_file(yaml)
				end
			end
		end

		def reload!
			self.load!
		end
  end
end