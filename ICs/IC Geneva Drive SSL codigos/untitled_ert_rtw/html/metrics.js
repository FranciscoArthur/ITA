function CodeMetrics() {
	 this.metricsArray = {};
	 this.metricsArray.var = new Array();
	 this.metricsArray.fcn = new Array();
	 this.metricsArray.var["rtDW"] = {file: "D:\\Documentos\\IC Geneva Drive Small\\Matlab\\untitled_ert_rtw\\untitled.c",
	size: 16};
	 this.metricsArray.var["rtM_"] = {file: "D:\\Documentos\\IC Geneva Drive Small\\Matlab\\untitled_ert_rtw\\untitled.c",
	size: 521};
	 this.metricsArray.var["rtX"] = {file: "D:\\Documentos\\IC Geneva Drive Small\\Matlab\\untitled_ert_rtw\\untitled.c",
	size: 16};
	 this.metricsArray.fcn["memcpy"] = {file: "D:\\MatLab\\sys\\lcc\\include\\string.h",
	stack: 0,
	stackTotal: 0};
	 this.metricsArray.fcn["untitled.c:rt_ertODEUpdateContinuousStates"] = {file: "D:\\Documentos\\IC Geneva Drive Small\\Matlab\\untitled_ert_rtw\\untitled.c",
	stack: 104,
	stackTotal: -1};
	 this.metricsArray.fcn["untitled_derivatives"] = {file: "D:\\Documentos\\IC Geneva Drive Small\\Matlab\\untitled_ert_rtw\\untitled.c",
	stack: 8,
	stackTotal: 8};
	 this.metricsArray.fcn["untitled_initialize"] = {file: "D:\\Documentos\\IC Geneva Drive Small\\Matlab\\untitled_ert_rtw\\untitled.c",
	stack: 0,
	stackTotal: 0};
	 this.metricsArray.fcn["untitled_step"] = {file: "D:\\Documentos\\IC Geneva Drive Small\\Matlab\\untitled_ert_rtw\\untitled.c",
	stack: 0,
	stackTotal: -1};
	 this.getMetrics = function(token) { 
		 var data;
		 data = this.metricsArray.var[token];
		 if (!data) {
			 data = this.metricsArray.fcn[token];
			 if (data) data.type = "fcn";
		 } else { 
			 data.type = "var";
		 }
	 return data; }; 
	 this.codeMetricsSummary = '<a href="untitled_metrics.html">Global Memory: 553(bytes) Maximum Stack: 104(bytes)</a>';
	}
CodeMetrics.instance = new CodeMetrics();
