class Conversion < ActiveRecord::Base
	mount_uploader :file, FileUploader
	validates :title, presence: true
	validate :file_size


	private

		#validates file size
		#i actually implemented validation on the client side, 
		#this is superfluous to some extent
		def file_size
			if file.size > 5.megabytes
				errors.add(:file, "should be less than 5MB")
			end
		end
end
