#!/usr/local/bin/node

var fs = require('fs')

var fileNames = process.argv.slice(2)

var coinsidesI = (s1, s2) => (i) => s1[i] === s2[i] && s1[i] !== ' '

var getStreak = (s1, s2, initial = 0) => {
    var coinsides = coinsidesI(s1, s2)
    var streak = ''
    var l = Math.min(s1.length, s2.length)
    for (var i = initial; i < l; i++) {
        if (coinsides(i)) {
            streak += s1[i]
        } else if (streak) {
            return { final: false, last: i, streak }
        }
    }

    return { final: true, last: i, streak }
}

var getStreaks = (s1, s2) => {
    var streaks = []
    var s = {}
    do {
        s = getStreak(s1, s2, s.last)
        if (s.streak) {
            streaks.push(s.streak)
        }
    } while (!s.final)

    return streaks
}

var texts = fileNames
    .map(path => fs.readFileSync(path))
    .map(String)
    .map(s => s.split('\n'))

var l = Math.min(...texts.map(file => file.length))

var destiny = []

for (var i = 0; i < l; i++) {
    var streaks = getStreaks(texts[0][i], texts[1][i])
    if (streaks.length) {
        destiny.push({ line: i + 1, streaks: streaks.join(' ') })
    }
}

destiny.forEach(d => console.log(`${d.line}: ${d.streaks}`))
