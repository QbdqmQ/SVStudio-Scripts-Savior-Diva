【关于本插件的使用】

如果能在工程或作品标注我的名字，我将不胜感激。

如果需要保存配置文件，则需要在英文目录下使用，工程也需命名为英文。

“动态方向” 针对每一个音符，而不是选中的区域。

若将非音高偏差的参数设为 0 ，则生成参数时不会生成该参数的控制点。

“振幅上限” “振幅下限” 决定 “动态方向” 的最大值和最小值， “动态方向” 为 “无” 时这两个参数无效。

个人建议：在使用本插件生成参数后，提升音区偏移的数值，更有利于得到本插件预想的效果。

在 "动态方向" 不为 “无” 时， “平滑参数” 可用于控制振幅峰值的变化速度。 
“平滑参数” 越大，振幅峰值变化越快（类似指数函数）。
“平滑参数” 越小，振幅峰值变化越慢（类似对数函数）。

如果你需要在一个工程内使用多个本插件的设置，你可以复制本插件，然后：
在 “获取项目文件名（用于配置文件）” 这个注释的下方代码修改 “ .SDGrowl.cfg ” 的名字。推荐修改成如 “ .SDGrowl.1.cfg ” 等以数字命名的后缀。
在下方 “getClientInfo” 修改本插件的名字。推荐修改成如 “Savior Diva - Growl_1” 等以数字命名的后缀。

本插件已经有预设好的参数。如果你需要修改参数的默认值，可以在下方 “local defaults” 修改。



[About Using This Plugin]

I would appreciate it if you could credit me in the work.

If you need to save the config file, it must be used in an English-named directory, and the project must also be named in English.

"Dynamics" applies to each individual note, not the selected area.

If parameters other than pitch are set to 0, control points for those parameters will not be generated during parameter generation.

"Range Min" and "Range Max" determine the maximum and minimum values of the "Dynamics". These two parameters are invalid when "Dynamics" is set to "None".

Personally recommend: Increasing the Tune Shift value after generating parameters with this plugin may better achieve its intended effect.

When "Dynamics" is not "None", the "Smooth" can be used to control the rate of change of the amplitude peak.
The larger the "Smooth", the faster the amplitude peak changes (similar to an exponential function).
The smaller the "Smooth", the slower the amplitude peak changes (similar to a logarithmic function).

If you need to use multiple settings of this plugin within one project, you can duplicate this plugin and then:
Modify the name of ".SDGrowl.cfg" in the code below the comment "获取项目文件名（用于配置文件）". It is recommended to change it to a numerically suffixed name such as ".SDGrowl.1.cfg".
Modify the name of this plugin in "getClientInfo" below. It is recommended to change it to a numerically suffixed name such as "Savior Diva - Growl_1".

This plugin already has preset parameters. If you need to modify the default values of the parameters, you can do so in "local defaults" below.
