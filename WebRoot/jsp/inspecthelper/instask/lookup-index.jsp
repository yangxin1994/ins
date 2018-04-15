<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<%@include file="../../util/head.jsp"%>
		<title>员工列表</title>
	</head>
	<body style="padding: 3px; border: 0px">
		<div id="lookup_tb" style="padding: 5px; height: auto">
			<div class="condition-container" style="width:80%;height:100px;">
				<form id="lookup_form" action="" method="post">
					<input type="hidden" id="ifGLY" />
					<input type="hidden" name="selected" value="" />
					<table class="condition" style="width:80%;">
						<tr>
							<td width="10%">
								姓名：
							</td>
							<td width="20%">
								<div class="condition-text-container">
									<input name="look_staff_name" type="text" class="condition-text" />
								</div>
							</td>
							<td width="10%">
								帐号：
							</td>
							<td width="20%">
								<div class="condition-text-container">
									<input name="look_staff_no" type="text" class="condition-text" />
								</div>
							</td>
						</tr>
						<tr>
							<td width="10%">
								地市：
							</td>
							<td width="20%">
								<select name="look_area" class="condition-select">
									<option value="">
										请选择
									</option>
									<c:forEach items="${areaList}" var="al">
										<option value="${al.AREA_ID}">
											${al.NAME}
										</option>
									</c:forEach>
								</select>
							</td>
							<td width="10%">
								区县：
							</td>
							<td width="20%">
								<select name="look_son_area" class="condition-select">
									<option value="">
										请选择
									</option>
								</select>
						</tr>
					</table>
				</form>
			</div>
			<div class="btn-operation-container" style="width:77%;">
				<div class="btn-operation" onClick="selectStaff()">选择</div>
				<div style="float: right;" class="btn-operation" onClick="searchLookUpData()">
					查询
				</div>
			</div>
		</div>
		<table id="lookup_dg" title="【员工管理】"></table>

	<script type="text/javascript">
		$(document).ready(function() {
			selectSelected();
			searchLookUpData();
		});
		
	function selectSelected(){
		$.ajax({
				type : 'POST',
				url : webPath + "Staff/selectSelected.do",
				dataType : 'json',
				async:false,
				success : function(json) {
				if(json[0].ifGly==1){			
				$("#ifGLY").val("0");
				}else{
				$("select[name='look_area']").val(${areaId});
				$("select[name='look_area']").attr("disabled","disabled");
				$("#ifGLY").val("1");
				}
				
				}
			});
		}
		function searchLookUpData() {
			var staff_name = $("input[name='look_staff_name']").val().trim();
			var staff_no = $("input[name='look_staff_no']").val().trim();
			var area = $("select[name='look_area']").val();
			var son_area = $("select[name='look_son_area']").val();
			var obj = {
				staff_name : staff_name,
				staff_no : staff_no,
				area : area,
				son_area : son_area
			};
			//return;
			$('#lookup_dg').datagrid({
				//此选项打开，表格会自动适配宽度和高度。
				autoSize : true,
				toolbar : '#lookup_tb',
				url : webPath + "Staff/query.do",
				queryParams : obj,
				method : 'post',
				pagination : true,
				pageNumber : 1,
				pageSize : 10,
				pageList : [ 20, 50 ],
				//loadMsg:'数据加载中.....',
				rownumbers :  false,
			
				singleSelect : true,
				columns : [ [ {
					field : 'STAFF_ID',
					title : '员工ID',
					checkbox:true
				},{
					field : 'STAFF_NAME',
					title : '员工姓名',
					width : "10%",
					align : 'center'
				}, {
					field : 'STAFF_NO',
					title : '员工帐号',
					width : "20%",
					align : 'center'
				}, {
					field : 'ROLE_NAME',
					title : '角色',
					width : "25%",
					align : 'center'
				}, {field : 'AREA',
					title : '地市',
					width : "13%",
					align : 'center'
				}, {
					field : 'SON_AREA',
					title : '区县',
					width : "15%",
					align : 'center'
				}] ],
				nowrap : false,
				striped : true,
				onLoadSuccess : function(data) {
       			 $(this).datagrid("fixRownumber");
				
				}
			});
		}
	

		$(function() {
			//查询
			if($("#ifGLY").val()=="1"){
				getSonAreaList('query');
			}else{
			$("select[name='look_area']").change(function() {
				//根据area_id，获取区县
				getSonAreaList('query');
			});
			}
		});

		function getSonAreaList(operator) {
			//	var areaId = $("select[name='area']").val();
			var area_id = 0;
			if ('query' == operator) {
				area_id = $("select[name='look_area']").find("option:selected")
						.val();
			} else if ('add' == operator) {
				area_id = $("select[name='varea']").find("option:selected")
						.val();
			}
			$.ajax({
				type : 'POST',
				url : webPath + "General/getSonAreaList.do",
				data : {
					areaId : area_id
				},
				dataType : 'json',
				success : function(json) {
					var result = json.sonAreaList;
					if ('query' == operator) {
						$("select[name='look_son_area'] option").remove();
						$("select[name='look_son_area']").append(
								"<option value=''>请选择</option>");
						for ( var i = 0; i < result.length; i++) {
							$("select[name='look_son_area']").append(
									"<option value=" + result[i].AREA_ID + ">"
											+ result[i].NAME + "</option>");
						}
					} else if ('add' == operator) {
					if($("#ifGLY").val()=="1"){
					$("select[name='varea']").attr("disabled","disabled")
					}
						$("select[name='vson_area'] option").remove();
						//$("select[name='vson_area']").append(
						//		"<option value=''>请选择</option>");
						for ( var i = 0; i < result.length; i++) {
							$("select[name='vson_area']").append(
									"<option value=" + result[i].AREA_ID + ">"
											+ result[i].NAME + "</option>");
						}
					}

				}
			});
		}
		
	function selectStaff(){
			var selected = $('#lookup_dg').datagrid('getChecked');
			var count = selected.length;
			if (count == 0) {
				$.messager.show({
					title : '提  示',
					msg : '请选取一条数据!',
					showType : 'show'
				});
				return;
			} else {
				$("#staffId").val(selected[0].STAFF_ID);
				$("#staffName").val(selected[0].STAFF_NAME);
				$('#win_staff').window('close');
			}
		}
	</script>

	</body>
</html>