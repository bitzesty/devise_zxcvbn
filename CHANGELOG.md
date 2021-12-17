## 6.0 - 2021-12-17

- Switching to [zxcvbn-rb](https://github.com/formigarafa/zxcvbn-rb) so that we do not need to run execjs but still keep compatability with Dropbox's zxcvbn.js.
  `zxcvbn-rb` is not the same as `zxcvbn-ruby` (which produces different scores which is why we originally used `zxcvbn-js`).

## 5.2 - 2021-12-17

- Fix Ruby 3.0 compatability
