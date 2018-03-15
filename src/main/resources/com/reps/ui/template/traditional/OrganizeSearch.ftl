<htmlTag>
	<style>
		ul.keySearch{
			border-width:0 1px 1px 1px;
			border-color:#A2BAC0;
			border-style:solid;
			width:${width!}px;
			margin-top:22px;
			position:fixed;
			background:#fff;
			padding:0 1px 0 1px;
		}
		ul.keySearch li{
			height:18px;
			line-height:18px;
			overflow:hidden;
		}
		ul.keySearch li:hover{
			background:#A2BAC0;
			cursor:pointer;
		}
	</style>
	<div style="posotion:relative;">
		<input name="${hideIdName!}" type="hidden" value="" />
		<input class="txtInput" id="${id!}" name="${name!}" style="width:${width!}px;height:20px;line-height:15px;" />
	</div>
</htmlTag>
<onload>
	$('input[name="${name!}"]').keySearch('${url!}');
</onload>