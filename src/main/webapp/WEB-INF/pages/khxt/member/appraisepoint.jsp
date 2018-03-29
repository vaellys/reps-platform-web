<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/commons/tags.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<title>评分</title>
<reps:theme />
<style type="text/css">
.fInput {
    text-align: center;
    height: 25px;
}
table.gridtable {
	font-family: verdana, arial, sans-serif;
	font-size: 11px;
	color: #333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
	width:90%;
	margin-left:0;
}

table.gridtable th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #d0d0d0;
	background-color: #EEE;
}

table.gridtable td {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #ededed;
	background-color: #ffffff;
    text-decoration: underline;
}

</style>
</head>
<body>
	<reps:container>
		<reps:panel id="myform" dock="top" action="add.mvc" formId="xform"
			validForm="true">
			<reps:formcontent>
				<reps:formfield label="考核人" fullRow="true" >
					${khrPersonName }
				</reps:formfield>
				<reps:formfield label="2月中层领导考核" fullRow="true" >
					<input type="hidden" name="memberJson" id="memberJson" value="">
					<input type="hidden" name="itemPointJson" id="itemPointJson" value="">
					<table class="gridtable" id="gridTable">
						<tbody>
							<tr>
								<th>被考核人</th>
								<c:forEach var="item" items="${items}" varStatus="status">
								<th>${item.name}<br>（<fmt:formatNumber value="${item.point}" pattern="#00.#"/>）</th>
								</c:forEach>
								<th>合计</th>
							</tr>
							<c:forEach var="member" items="${performanceMembers}" varStatus="status">
								<tr>
									<td><reps:dialog cssClass="" id="detail" iframe="true" width="600"
								 height="200" url="workdetail.mvc?sheetId=${member.appraiseSheet.id }&personId=${member.bkhrPerson.id }" value="${member.bkhrPerson.name }"></reps:dialog></td>
									<c:forEach var="item" items="${items}" varStatus="s">
										<td><input class="txtInput moneyvalidate required" name="point${status.count }${s.count }"  value=""  itemId="${item.id }" memberId="${member.id }" max="${item.point }" min="0" onkeyup="return calculateTotalPoint($('#totalPoint${status.count }'), '${status.count }')"></td>
									</c:forEach>
									<td><input class="txtInput moneyvalidate required" name="totalPoint${status.count }" id="totalPoint${status.count }" memberId="${member.id }" value="" readonly="readonly"></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</reps:formfield>
				
			</reps:formcontent>
			</br>
			</br>
			<reps:formbar>
				<reps:ajax messageCode="add.button.save" formId="xform"
					callBack="my" type="button" cssClass="btn_save" beforeCall="buildMemberAndItemJson()"></reps:ajax>
				<reps:button cssClass="btn_cancel_a" messageCode="add.button.cancel"
					onClick="back()"></reps:button>
			</reps:formbar>
		</reps:panel>
	</reps:container>
</body>
<script type="text/javascript">
	var my = function(data) {
		messager.message(data, function() {
			back();
		});
	};

	function back() {
		window.location.href = "${ctx}/reps/khxt/appraise/listpoint.mvc";
	}
	
	function calculateTotalPoint($obj, index) {
		var totalPoint = 0;
		$("input[name^='point" + index + "']").each(function(){
			var val = parseFloat($(this).val());
			if (!isNaN(val)) {
				totalPoint += val;
			}
		});
		$obj.val(totalPoint);
	}
	
	
	function buildMemberAndItemJson() {
		var memberArray = new Array();
		$("#gridTable input[name^='totalPoint']").each(function() {
			var memberId = $(this).attr("memberId");
			var totalPoint = $(this).val();
			memberArray.push(new Member(memberId, totalPoint));
		});
		var memberJsonStr = JSON.stringify(memberArray);
		$("input[name='memberJson']").val(memberJsonStr);

		var itemPointArray = new Array();
		$("#gridTable input[name^='point']").each(function() {
			var memberId = $(this).attr("memberId");
			var itemId = $(this).attr("itemId");
			var point = $(this).val();
			itemPointArray.push(new ItemPoint(memberId, itemId, point));
		});
		var itemPointJsonStr = JSON.stringify(itemPointArray);
		$("input[name='itemPointJson']").val(itemPointJsonStr);

		return true;
	}

	function Member(memberId, totalPoint) {
		this.memberId = memberId;
		this.totalPoint = totalPoint;
	}

	function ItemPoint(memberId, itemId, point) {
		this.memberId = memberId;
		this.itemId = itemId;
		this.point = point;
	}
</script>
</html>