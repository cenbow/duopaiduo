<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>首页</title>
<link rel="Stylesheet" href="css/style.css" type="text/css" />
<link rel="Stylesheet" href="css/public/font-awesome.min.css" type="text/css" />
<!-- jQuery -->
<script type="text/javascript" src="js/public/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="js/public/bootstrap.min.js"></script>
<script type="text/javascript" src="js/public/layer/layer.js"></script>
<script type="text/javascript" src="js/public/laydate/laydate.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript" src="js/jquery.cookie.js"></script>
<script type="text/javascript">
	$(function(){
		if($.cookie('name') != null && $.cookie('name') != ""){
			 $("#sp").html( $.cookie('name'));
		 }else{
			 layer.msg("登录超时！");
			window.location.href="login.jsp";
		 }
		$.ajax({
			url : "bannflData",
			type : 'POST',
			dataType : 'JSON',
			async:false,
			success : function(data) {
				//var datas=JSON.parse(data.list);
				var datas=eval(data);
				//console.log(datas);
				var htm = ' <option value=0 >广告分类</option>';
				$.each(datas,function(i,obj){
					htm +=' <option value='+obj.banner_id+'>'+obj.banner_name+'</option>';
				});
				$("#xiala").html(htm);
				$("#xiala").val($("#banner_id").val());
			},
			error : function() {
				alert("网络异常！");
			}
		});
		var isShows=$('#isShows').val()!=''? $('#isShows').val() : 0;
		$('input[name=isShows][value='+isShows+']').attr("checked",true);
	});
	
	//添加
	function save(x){
		var remark;
		var isShow;
		if(x==2){
			if($("#remark").val() == null || $("#remark").val() == ""){
				layer.msg("拒绝审批意见必填!");
				return;
			}else{
				remark = $("#remark").val();
				isShow = 0;
			}
		}else{
			remark = $("#remark").val();
			isShow = 1;
		}
		var banner_id=$("#xiala").val();
			if(banner_id == 0 || banner_id == ""){
				 layer.msg("分类必选!");
				 return;
			 }
		var uri=$("#imgUri").val();
			if(uri == null || uri == ""){
				 layer.msg("图片必填!");
				 return;
			 }
		var title=$("#title").val();
			if(title == null || title == ""){
				 layer.msg("标题必填!");
				 return;
			 }
		var url=$("#url").val();
			if(url == null || url == ""){
				 layer.msg("广告链接必填!");
				 return;
			 }
		var start_time=$("#start_time").val();
			if(start_time == null || start_time == ""){
				 layer.msg("开始必填!");
				 return;
			 }
		var end_time=$("#end_time").val();
			if(end_time == null || end_time == ""){
				 layer.msg("结束时间必填!");
				 return;
			 }
		var creator=$("#creator").val();
			
		var sort=$("#sort").val();
			if(sort == null || sort == ""){
				 layer.msg("排序必填数字!");
				 return;
			 }
		
		var param ={
				"menu.id" : $("#adId").val(),
				"menu.banner_id" : banner_id,
				"menu.uri" : uri,
				"menu.title" : title,
				"menu.url" : url,
				"menu.start_time" : start_time,
				"menu.end_time" : end_time,
				"menu.isShow" : isShow,
				"menu.sort" : sort,
				"menu.remark" : remark,
				"menu.status" : x
				
		};
		$.ajax({
			url : "adUpdate",
			type : 'POST',
			dataType : 'JSON',
			data : param,
			async:false,
			success : function(data) {
				if(data){
					alert("保存成功!");
					window.location.href="advert.jsp";
				}else{
					alert("失败!");
				}
			},
			error : function() {
				alert("网络异常！");
			}
	 });
	};
	function empty(){
		
		$("#remark").val("");
		$("#xiala").val("");
		$("#uri").val("");
		$("#title").val("");
		$("#url").val("");
		$("#start_time").val("");
		$("#end_time").val("");
		$("#sort").val("");
		
	}
	
</script>
</head>

<body>

<div id="container" class="thewidth100">

<!--header-->
    <div class="header_bg clearfix thewidth100"> 
        <div class="header_top clearfix">
            <div class="f_l">logo 多拍多资讯站后台管理</div>
            <div class="f_r">欢迎 <span id="sp"></div>
        </div>
        <div class="header">
            <nav>
                <ul>
                    <li><a href="">管理首页</a></li>
                    <li><a href="wenz.jsp" >文章管理</a></li>
                    <li><a href="advert.jsp" class="choice">广告管理</a></li>
                    <li><a href="">用户管理</a></li>
                    <li><a href="">评论管理</a></li>
                    <li><a href="system.jsp">系统管理</a></li>
                </ul>
            </nav>
        </div>
    </div>
<!--------------------------------------[ header ]-------------------------------------->


<!--wrap-->
    <div class="wrap_bg thewidth100">    
        <div class="wrap clearfix bghui">

            <div class="wrap_l">
            <h2>广告管理</h2>
                <ul>
                    <li><a href="advert.jsp">广告列表</a></li>
                    <li><a href="addAdvert.jsp">添加广告</a></li>
                    <li><a href="trialAdvert.jsp">审核广告列表</a></li>
                </ul>
            </div>
            <div class="wrap_r">
                <div class="clearfix SearchOperation">
                    <h4>审核广告</h4>
                </div>
                <div class="modify">
                    <form>
                    	<input type="hidden" id="adId" value="${ad.id }"/>
                    	<input type="hidden" id="banner_id" value="${ad.bannerId }"/>
                        <table class="table table-bordered">
                            <tbody>
                                <tr>
                                    <td>广告标题:</td>
                                    <td><input type="text" class="form-control f_l" disabled id="title" value="${ad.title }" placeholder="请填写广告标题"></td>
                                </tr>
                                <tr>
                                    <td>广告分类:</td>
                                    <td align="left">
                                        <select disabled id="xiala" class="form-control f_l">
                                              <option>选择所属文章分类</option>
                                              <option>酒业资讯</option>
                                              <option>酒厂动态</option>
                                              <option>餐厅美食</option>
                                              <option>酒文化</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>广告链接：</td>
                                    <td><input type="text" class="form-control f_l" id="url" disabled value="${ad.url }" placeholder=""></td>
                                </tr>
                                <tr>
                                    <td>上传图片：</td>
                                    <td>
                                    	<div class="clearfix">
		                                	<!-- <input id="imgfile" class="f_l" type="file" name="imgfile" /> -->
											<input type="text" disabled value="${ad.uri }" style="display: none;" id="imgUri" name="img_uri" ">
										    <!-- <input type="button" class="f_l ma_l10" value="上传" id="imgUpload" onclick="btnUpload()"> -->
		                                </div>
									    <img alt=""  src="/dobado_info/${ad.uri }" style=" float:left; height:100px; width: 100px;" id="showImg" >
                                    </td>
                                </tr>
                                <tr>
                                    <td>状态：</td>
                                    <td>
                                    	<input type="hidden" id="isShows" value="${ad.isShow }"/>
                                        <label disabled class="f_l"><input type="radio" name="isShows" value="1" />显示</label>
                                        <label disabled class="ma_l20 f_l"><input type="radio" name="isShows" value="0" checked/>隐藏</label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>排序：</td>
                                    <td><input disabled type="text" class="form-control f_l" id="sort" value="${ad.sort }" placeholder=""></td>
                                </tr>
                                <tr>
                                    <td>开始时间：</td>
                                    <td>
                                        <div class="form-group f_l sj">
                                            <input id="start_time" disabled value="${ad.startTime }"style="left: 0px; top: -2px; border: 1px solid rgb(204, 204, 204);" type="text" class="form-control laydate-icon" placeholder="开始时间">
                                        </div>
                                       <!-- 
                                       <div class="form-group f_l sj">
                                            <input id="start_time" value="${ad.startTime }" type="text" class="form-control" placeholder="开始时间">
                                            <span class="laydate-icon" onclick="laydate({elem: '#start_time',istime: true, format: 'YYYY-MM-DD hh:mm:ss'});"></span>
                                        </div>
                                        -->
                                    </td>
                                </tr>
                                <tr>
                                    <td>结束时间：</td>
                                    <td>
                                        <div class="form-group f_l sj">
                                            <input id="end_time" disabled value="${ad.endTime }"style="left: 0px; top: -2px; border: 1px solid rgb(204, 204, 204);" type="text" class="form-control laydate-icon " placeholder="结束时间">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                <td>审批意见：</td>
                                    <td>
                                        <textarea id="remark" class="form-control" name="" placeholder="主编：XXX   时间： 2016-07-01       "></textarea>
                                    </td>
                                </tr> 
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <button type="button" onclick="save(1)" class="btn btn-default f_l">通过</button>
                                        <button type="button" onclick="save(2)" class="btn btn-default ma_l20 f_l">拒绝</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </form>
                    <br><br><br>
                </div> 
            </div>
        </div>      
    </div>
<!--/wrap-->
<script type="text/javascript">
function btnUpload(){  
	var elementIds=["imgUri"]; //flag为id、name属性名
	 $.ajaxFileUpload({
          url: 'upload', 
          type: 'post',
          secureuri: false, //
          fileElementId: 'imgfile', // 
          dataType: 'application/json', //
          elementIds: elementIds, //
          success: function(data){ 
        	// console.log(data);
        	 var dat = JSON.parse(data.substring(5,data.indexOf("</pre>")));
        	 if(dat.data){
        		 alert("成功");
	          	 $('#imgUri').val(dat.re);
	          	 //alert($('#imgUri').val());
	          	aaa("imgUri");
        	 }else{
        		 alert("失败");
        	 }
          }
	})
} 
function aaa(a){
	 $('#showImg').attr('src',"/"+$("#"+a).val()).show();
}
</script>

<!--------------------------------------[ footer ]-------------------------------------->
    <div class="footer_bg thewidth100">
        <div class="footer">
        
        
        
        </div>
    </div>
<!--/footer-->

</div>
<script>
var start = {
    elem: '#start_time',
    format: 'YYYY-MM-DD hh:mm:ss',
    min: laydate.now(), //设定最小日期为当前日期
    max: '2099-06-16 23:59:59', //最大日期
    istime: true,
    istoday: true,
    choose: function(datas){
         end.min = datas; //开始日选好后，重置结束日的最小日期
         end.start = datas //将结束日的初始值设定为开始日
    }
};
var end = {
    elem: '#end_time',
    format: 'YYYY-MM-DD hh:mm:ss',
    min: laydate.now(),
    max: '2099-06-16 23:59:59',
    istime: true,
    istoday: false,
    choose: function(datas){
        start.max = datas; //结束日选好后，重置开始日的最大日期
    }
};
laydate(start);
laydate(end);
</script>
</body>
</html>