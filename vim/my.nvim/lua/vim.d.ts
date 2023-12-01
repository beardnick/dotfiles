declare const vim: {
  notify: (this: void, msg: string) => void,
  g: any
  fn: {
    isdirectory: (this: void, path: string) => number,
  }
};
