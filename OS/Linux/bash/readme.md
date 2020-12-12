### Command chaining in Terminal(sh?)
1.A ; B - Run A and then B, regardless of the success of A
<br/>
2.A && B - Run B only if A succeeded
<br/>
3.A || B - Run B only if A failed

### Terminal with Vim
1) One way to do this is to
	a. Ctrl+Z , sends the job to the foreground
	<br/>	
	b. Use terminal for whatever...
	<br/>
	c. <i>fg</i> command to go back to the foreground job
	<br/>
	d. or, <i>jobs</i> to list all the jobs, and <i>%job_number</i> to switch to the job we want.. 
	<br/>
2) Second way is to:
	a. <i>Shift+;</i> in vim, which opens vim's command line
	<br/>
	b. <i>:!</t> + commands
	<br/>
	g. or <i>:shell</i> + commands
	<br/>
