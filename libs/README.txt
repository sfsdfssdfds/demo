微信内置浏览器经常无法稳定访问外部 CDN（jsdelivr/unpkg），并且 Tesseract 运行时还会继续拉取 worker/wasm/语言包。
因此本项目把 OCR 依赖改为“同域本地文件优先”。请把下面文件放到本目录（与 index.html 同域可访问）：

必需文件（Tesseract.js v5）：
1) tesseract.min.js
2) worker.min.js
3) tesseract-core.wasm.js
4) eng.traineddata.gz   （语言包，英文数字即可）

可选（不同构建/加速用，放了也没坏处）：
- tesseract-core-simd.wasm.js
- tesseract-core.wasm
- tesseract-core-simd.wasm

放置完成后：
- 浏览器打开页面，控制台里 window.Tesseract 应该存在
- 上传图片后会直接从 ./libs 读取 worker/core/lang，不再依赖外链

注意：
- 文件名必须与上面一致（区分大小写）
- GitHub Pages/任意静态站点都可以，只要这些资源与页面同域可访问

