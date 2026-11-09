import { execFileSync } from 'node:child_process'
import { mkdirSync, readFileSync, writeFileSync, copyFileSync } from 'node:fs'
import { dirname, join, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const brandingDir = dirname(fileURLToPath(import.meta.url))
const projectDir = resolve(brandingDir, '..')
const source = join(projectDir, 'client/images/bee-lazy-logo.jpg')
const png = join(brandingDir, 'bee-lazy-icon.png')
const iconBundle = join(brandingDir, 'BeeLazyAppIcon.icon')
const iconAssets = join(iconBundle, 'Assets')

execFileSync('ffmpeg', [
  '-v', 'error', '-y', '-i', source,
  '-vf', 'scale=512:512:flags=lanczos', '-frames:v', '1', png
])

const pngBytes = readFileSync(png)
const icoHeader = Buffer.from([0, 0, 1, 0, 1, 0])
const icoEntry = Buffer.alloc(16)
icoEntry.writeUInt8(0, 0)
icoEntry.writeUInt8(0, 1)
icoEntry.writeUInt8(0, 2)
icoEntry.writeUInt8(0, 3)
icoEntry.writeUInt16LE(1, 4)
icoEntry.writeUInt16LE(32, 6)
icoEntry.writeUInt32LE(pngBytes.length, 8)
icoEntry.writeUInt32LE(22, 12)

writeFileSync(join(projectDir, 'client/images/app.ico'), Buffer.concat([icoHeader, icoEntry, pngBytes]))

const icnsHeader = Buffer.alloc(8)
icnsHeader.write('icns', 0, 'ascii')
icnsHeader.writeUInt32BE(pngBytes.length + 16, 4)
const icnsEntry = Buffer.alloc(8)
icnsEntry.write('ic09', 0, 'ascii')
icnsEntry.writeUInt32BE(pngBytes.length + 8, 4)
writeFileSync(join(brandingDir, 'BeeLazyAppIcon.icns'), Buffer.concat([icnsHeader, icnsEntry, pngBytes]))

mkdirSync(iconAssets, { recursive: true })
const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512"><image width="512" height="512" href="data:image/png;base64,${pngBytes.toString('base64')}"/></svg>`
writeFileSync(join(iconAssets, 'bee-lazy-mark.svg'), svg)
writeFileSync(join(iconBundle, 'icon.json'), JSON.stringify({
  fill: {
    'linear-gradient': [
      'srgb:0.98431,0.98431,0.95686,1.00000',
      'srgb:0.94902,0.94902,0.89020,1.00000'
    ],
    orientation: { start: { x: 0.5, y: 0 }, stop: { x: 0.5, y: 1 } }
  },
  groups: [{ layers: [{ name: 'bee-lazy-mark', 'image-name-specializations': [{ value: 'bee-lazy-mark.svg' }] }] }],
  'supported-platforms': { squares: 'shared' }
}, null, 2) + '\n')

const androidLogo = join(projectDir, 'client/android/res/drawable-nodpi/bee_lazy_logo.png')
mkdirSync(dirname(androidLogo), { recursive: true })
copyFileSync(png, androidLogo)
