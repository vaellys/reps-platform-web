<htmlTag>
<a <#if cssClass??>class="${cssClass}"</#if> <#if id??>id="${id}"</#if> target="upload" style="cursor:pointer"><span>${value?if_exists}</span></a>
</htmlTag>
<onload>
$("#${id?if_exists}",$p).setupUploader({"id":"${id?if_exists}","path":"${path?if_exists}","url":"${url?if_exists}","callback":"${callback?if_exists}","action":"${absolutePath?if_exists}","flagAbsolute":${flagAbsolute?if_exists?string("true","false")}<#if fileType??>,"fileType":"${fileType!}"</#if>,"reName":"${reName?string("true","false")}","fileName":"${fileName!}","coverage":"${coverage?string("true","false")}","prefixName":"${prefixName!}","suffixName":"${suffixName!}","size":${size!}});
</onload>