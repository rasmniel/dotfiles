-- Import all files to use in tidal environment.
-- Use :load Main in BootTidal.hs to include all imports from this file into the scope.

import Util.Playback
import Util.Transpose

-- Main is necessary for the project to have an entry point.
-- The function is a no-op because this project isn't executable.

main :: IO ()
main = return ()
