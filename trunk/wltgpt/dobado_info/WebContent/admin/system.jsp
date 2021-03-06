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
<script type="text/javascript" src="js/public/laypage/laypage.js"></script>
<script type="text/javascript" src="js/common.js"></script>
<script type="text/javascript" src="js/jquery.cookie.js"></script>
<script type="text/javascript">
	$(function(){
		if($.cookie('name') != null && $.cookie('name') != ""){
			 $("#sp").html( $.cookie('name'));
			 erjigaibian(1);
		 }else{
			 layer.msg("登录超时！");
			window.location.href="login.jsp";
		 }
	});
	
	function erjigaibian(curr){
		/*  var articleCategoryId=$('#xiala').val();
		 var isShow=$('#xians').val();
		 var wenztitle=$("#wenztitle").val();
		 var addTime=$("#addTime").val(); */
		 $.ajax({
				url : "youqingData",
				type : 'POST',
				dataType : 'JSON',
				data : {
					page: curr,
					rows : 10
					},
				//async:false,
				success : function(data) {
					//var datas=JSON.parse(data);
					var datas = eval(data);
					//console.log(datas);
					$("#pages").val(datas.pageNumber);
					var neirhtm = '';
					$.each(datas.list,function(i,obj){
						neirhtm +='<tr>';
						neirhtm +='<td>'+obj.navigation_name+'</td>';
						neirhtm +='<td>'+obj.navigation_url+'</td>';
						if(obj.status == 0)
							neirhtm +='<td>影藏</td>';
						if(obj.status == 1)
							neirhtm +='<td>显示</td>';
						neirhtm +='<td>';
						neirhtm +='<a href="linkup?lid='+obj.navigation_id+'"><button type="button" class="btn btn-default ">编辑</button></a>';
						neirhtm +='<button type="button" onclick="deleteid('+obj.navigation_id+')" class="btn btn-default ma_l20">删除</button>';
						neirhtm +='</td>';
						neirhtm +='</tr>';
					});
					$("#neirhtm").html(neirhtm);
					
					laypage({
					    cont: 'page', //容器。值支持id名、原生dom对象，jquery对象。【如该容器为】：<div id="page1"></div>
					    pages: (datas.totalPage),   //通过后台拿到的总页数
					    curr: curr, //当前页
					    jump: function(obj, first){ //触发分页后的回调
					        if(!first){ //点击跳页触发函数自身，并传递当前页：obj.curr
					       	erjigaibian(obj.curr)
					        }
					    }
					});
				},
				error : function() {
					alert("网络异常！");
				}
		 });
	 }
	function deleteid(ids){
		layer.confirm('确定删除',function(){ 
			$.ajax({
				url : "daohangBDelete",
				type : 'POST',
				dataType : 'JSON',
				data:{ids:ids},
				async:false,
				success : function(data) {
					if(data>0){
						layer.msg('删除成功！');
						erjigaibian($("#pages").val());
					}else{
						layer.msg('删除失败！请联系管理员');
					}
				},
				error : function() {
					alert("网络异常！");
				}
			});
		});
	}
</script>
</head>

<body>

<div id="container" class="thewidth100">

<!--header-->
    <div class="header_bg clearfix thewidth100"> 
        <div class="header_top clearfix">
            <div class="f_l">logo 多拍多资讯站后台管理</div>
            <div class="f_r">欢迎<span id="sp"></span></div>
        </div>
        <div class="header">
            <nav>
                <ul>
                    <li><a href="">管理首页</a></li>
                    <li><a href="wenz.jsp" >文章管理</a></li>
                    <li><a href="advert.jsp">广告管理</a></li>
                    <li><a href="">用户管理</a></li>
                    <li><a href="">评论管理</a></li>
                    <li><a href="system.jsp" class="choice">系统管理</a></li>
                </ul>
            </nav>
        </div>
    </div>
<!--------------------------------------[ header ]-------------------------------------->


<!--wrap-->
    <div class="wrap_bg thewidth100">    
        <div class="wrap clearfix bghui">
			<input type="hidden" id="pages" valur="" />
            <div class="wrap_l">
            <h2>系统管理</h2>
                <ul>
                    <li><a href="" class="choice">友情链接</a></li>
                    <li><a href="addLinks.jsp">添加链接</a></li>
                    <li><a href="nva.jsp">导航列表</a></li>
                   <!--  <li><a href="">添加导航</a></li>
                    <li><a href="systems.html">系统设置</a></li>
                    <li><a href="cache.html">缓存管理</a></li> -->
                </ul>

            </div>
            <div class="wrap_r">
                <div class="clearfix SearchOperation">
                    <h4 class="f_l">友情链接</h4>
                    <a href="addLinks.jsp"> <button type="submit" class="btn btn-default f_r">添加</button> </a>
                </div>
                <div class="table">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>链接名称</th>
                                <th>链接地址</th>
                                <th>显示</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody id="neirhtm">
                            
                        </tbody>
                    </table>
                </div>
                <div id="page"></div>
            </div>
        </div>    
    </div>
<!--/wrap-->


<!--------------------------------------[ footer ]-------------------------------------->
    <div class="footer_bg thewidth100">
        <div class="footer">
        
        
        
        </div>
    </div>
<!--/footer-->

</div>


</body>
</html>