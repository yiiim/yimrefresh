# yimrefresh
A Refresh Control Like Android

emmmmmm......我不是故意背叛iOS的。
是因为WKWebView有个bug，postion:fixed定位的tabBar，如果存在contentInset的话，定位会失效，所以才写这个么东西，不改变contentInset的刷新控件。

刷新效果:

![Untitled2.gif](http://ybz-1251448224.cossh.myqcloud.com/dir/Untitled2.gif)

导入方式：

> pod 'yimrefresh'

使用方式：

```
[self.tableView addYIMHeaderRefresh:^{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView endRefresh];
    });
}];

```
修改主题颜色：

> self.tableView.yim_header.tintColor = [UIColor redColor];

移除刷新控件

>  [self.tableView removeYIMHeaderRefresh];
