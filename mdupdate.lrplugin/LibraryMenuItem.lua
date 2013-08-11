
local LrView = import 'LrView'
local LrTasks = import "LrTasks"
local LrApplication = import 'LrApplication'
local LrLogger = import 'LrLogger'
local LrFunctionContext = import "LrFunctionContext"
local LrBinding = import "LrBinding"
local LrDialogs = import "LrDialogs"
local LrTasks = import 'LrTasks'
local LrProgressScope = import 'LrProgressScope'


local catalog = LrApplication.activeCatalog()

local function photosCount(photos)
	local count = 0
 	for _ in pairs(photos) do count = count + 1 end
 	return count
end

local function updateCameraInfo(photos, manufacturer, model)
	local progress = LrProgressScope( {title = 'Updating Camera Information' } )
	local count = 0
	local totalCount = photosCount(photos)

	for _, photo in ipairs(photos) do
		count = count + 1
		local path = photo:getRawMetadata( 'path' )
    	progress:setPortionComplete(count, totalCount)

    	LrTasks.execute( "exiftool -overwrite_original_in_place -preserve \'-Make="
    		..manufacturer.."\' -preserve \'-Model="..model.."\' \'"..path.."\'" )
	end
	progress:done()
end


local function ShowMetadataUpdateDialog()


	LrTasks.startAsyncTask( function()

		LrFunctionContext.callWithContext("CameraInfoDialog", function(context)

			local f = LrView.osFactory()
			local p = LrBinding.makePropertyTable(context)

			p.manufacturer = 'Canon'
			p.model = 'Canon PowerShot S40'

			local contents =  f:group_box { 
				bind_to_object = p,
				fill_horizontal = 1,

				f:row {
					f:static_text {
						title = "Camera Manufacturer:",
						alignment = "right",
						width = LrView.share("label_width"),
					},
					f:edit_field {
						value = LrView.bind( "manufacturer" ) ,
					}
				},	
				f:row {
					f:static_text {
						title = "Camera Model:",
						alignment = "right",
						width = LrView.share("label_width"),
					},
					f:edit_field {
						value = LrView.bind( "model" ) ,
					},
				},	

			}


			local result = LrDialogs.presentModalDialog({
				title = "Update Camera Model Information",
				contents = contents,
			})

			if result == "ok" then
				updateCameraInfo(catalog.targetPhotos, p.manufacturer, p.model)
			end

		end)


	end)

end




ShowMetadataUpdateDialog()