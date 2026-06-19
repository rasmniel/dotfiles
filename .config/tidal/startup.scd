/*
 * The startup file can be lives in Platform.userAppSupportDir +/+ "startup.scd"
 */

(
s.reboot {
	// Configure the sound server: here you could add hardware specific options.
	//  http://doc.sccode.org/Classes/ServerOptions.html
	s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
	s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
	s.options.numWireBufs = 2048; // increase this if you get "exceeded number of interconnect buffers" messages
	s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
	s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
	s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary

	// Wait for the server to boot, then start SuperDirt and load sample library.
	s.waitForBoot {
		// Whether only CC0 samples are allowed to be loaded into SuperDirt for commercial-use production.
		var clean = false;

		// Attempt to stop existing SuperDirt instances to avoid duplicate instances.
		// If "duplicate node ID" errors still appear in the post window, restart SuperCollider.
		~dirt.stop;

		// Install Clean-Samples quark if not already installed.
		(if (Quarks.isInstalled("Clean-Samples").not) {
			Quarks.install("Clean-Samples");
		});

		// Create SuperDirt instance with two output channels.
		// Can be increase to pan across more channels.
		~dirt = SuperDirt(2, s);

		// Load sound files. If CC0 is not required, just load the default, built-in Dirt-Samples library.
		(if (clean.not) { ~dirt.loadSoundFiles } {
			// If CC0 is required, cherry pick samples from Clean-Samples.
			var cleanDir = Platform.userExtensionDir +/+ "samples/Clean-Samples/";
			// The tr808-fischer is the baseline drumkit, including stables such as bd, sd, and cp.
			~dirt.loadSoundFiles(cleanDir +/+ "sounds-tr808-fischer/*", false, { |name|
				// Replace the 8 at the end of the name to use conveniently e.g. as bd instead of bd8.
				name.basename.drop(-1)
			});
			~dirt.loadSoundFileFolder(cleanDir +/+ "samples-cello-bowed", "celb");
			~dirt.loadSoundFileFolder(cleanDir +/+ "samples-cello-plucked", "celp");
			~dirt.loadSoundFileFolder(cleanDir +/+ "samples-flbass", "flb");
			~dirt.loadSoundFileFolder(cleanDir +/+ "samples-ukulele", "uku");
			~dirt.loadSoundFileFolder(cleanDir +/+ "sounds-repetition/repetition", "rep");
			~dirt.loadSoundFileFolder(cleanDir +/+ "sounds-wavestab/wavestab", "wtab");
		});

		s.sync;

		// Output the entire loaded soundLibrary keyset after initialization.
		"\n".postln;
		"The loaded sound library contains the following samples.".postln;
		(if (clean) {
			"All loaded samples are CC0 compliant and can be used in commercial production!".postln;
		});
		"".postln;
		"KEY       FILES".postln;
		"---------------".postln;
		~dirt.soundLibrary.buffers.keys.asArray.sort.do { |key|
			var buffer = ~dirt.soundLibrary.buffers[key];
			(key.asString.padRight(16, " ") ++ buffer.size.asString.padLeft(3, " ")).postln;
		};
		"".postln;

		// Start listening on port 57120. Create two busses each sending audio to channel 0.
		~dirt.start(57120, 0 ! 12);

		// Make the instance available in sclang.
		SuperDirt.default = ~dirt;
		// Convenient access from sclang.
		(
			~d1 = ~dirt.orbits[0]; ~d2 = ~dirt.orbits[1]; ~d3 = ~dirt.orbits[2];
			~d4 = ~dirt.orbits[3]; ~d5 = ~dirt.orbits[4]; ~d6 = ~dirt.orbits[5];
			~d7 = ~dirt.orbits[6]; ~d8 = ~dirt.orbits[7]; ~d9 = ~dirt.orbits[8];
			~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
		);

		// directly below here, in your own copy of this file, you could add further code that you want to call on startup
		// this makes sure the server and ~dirt are running
		// you can keep this separate and make it easier to switch between setups
		// by using "path/to/my/file.scd".load and if necessary commenting out different load statements
		// ...

	};

	s.latency = 0.3; // Increase this if consistently seeing "late" messages in the post window.
};
);
