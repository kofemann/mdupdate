--[[----------------------------------------------------------------------------

Info.lua
meta data updater plugin
------------------------------------------------------------------------------]]

return {

	LrSdkVersion = 4.0,
	LrSdkMinimumVersion = 3.0, -- minimum SDK version required by this plugin

	LrToolkitIdentifier = 'net.kofemann.lightroom.mdupdate',
	LrPluginName = LOC 'Metadata updater',
	VERSION = { major=1, minor=0, revision=1, build=1,  },


    LrLibraryMenuItems = {
    	{
			title = 'Update files metadata',
			file = 'LibraryMenuItem.lua',
			enabledWhen = 'photosSelected',
		},
	},
}
