class Conversion < ActiveRecord::Base
	mount_uploader :file, FileUploader
	validates :title, presence: true
	validate :file_size


	private

		# validates file size
		def file_size
			if file.size > 5.megabytes
				errors.add(:file, "should be less than 5MB")
			end
		end
end
