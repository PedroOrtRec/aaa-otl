// Keep Dynamic Lights enabled for non-shader users, but disable per-player lights
// when Iris shaders are active to avoid player-model flicker with Photon.

const DlAutoToggleState = {
	pending: false,
	tries: 0,
	tick: 0,
}

function isIrisShadersEnabled() {
	try {
		const Iris = Java.loadClass('net.irisshaders.iris.Iris')
		return !!Iris.getIrisConfig().areShadersEnabled()
	} catch (e) {
		return false
	}
}

function trySyncDynamicLightsForPlayer() {
	if (!Client.player) {
		return
	}

	const wantIgnored = isIrisShadersEnabled()
	const isIgnored = Client.player.hasTag('ts.dl.ignore')

	if (wantIgnored === isIgnored) {
		DlAutoToggleState.pending = false
		return
	}

	// /trigger ts.dl.toggle is the datapack-supported way to toggle self lighting.
	Client.player.runCommandSilent('trigger ts.dl.toggle')
	DlAutoToggleState.tries++

	if (DlAutoToggleState.tries >= 20) {
		DlAutoToggleState.pending = false
		console.info('[AAA OTL] Dynamic Lights auto-toggle reached max attempts.')
	}
}

ClientEvents.loggedIn(event => {
	DlAutoToggleState.pending = true
	DlAutoToggleState.tries = 0
	DlAutoToggleState.tick = 0
})

ClientEvents.loggedOut(event => {
	DlAutoToggleState.pending = false
	DlAutoToggleState.tries = 0
	DlAutoToggleState.tick = 0
})

ClientEvents.tick(event => {
	if (!DlAutoToggleState.pending) {
		return
	}

	DlAutoToggleState.tick++
	if (DlAutoToggleState.tick % 20 !== 0) {
		return
	}

	trySyncDynamicLightsForPlayer()
})

console.info('[AAA OTL] Loaded client script: Dynamic Lights auto-toggle for Iris shaders')

