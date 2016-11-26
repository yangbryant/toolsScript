## .gbashrc


#### 1. 实用说明：

- 安装`cdiff`工具
- 文件放在用户根目录下
- 在~/.bash_profile文件内添加如下配置

	```
	if [ -f ~/.gbashrc ]; then
    	. ~/.gbashrc
	fi
	```
	
- 重启Terminal即可.
- 进入repo,使用git df指令验证是否成功.

#### 2. 依赖库:

- `cdiff` <https://github.com/ymattw/cdiff>
- `stty` 
- `cut`


#### Notice

- 无

#### LICENSE
MIT.
