package com.daycare.daycareteacher.model

import com.google.gson.annotations.SerializedName

class DailySheetSaveResponse {
    @SerializedName("totalPages")
     var totalPages: Int? = null
    @SerializedName("totalRows")
     var totalRows: Int? = null
    @SerializedName("pageSize")
     var pageSize: Int? = null
    @SerializedName("id")
     var id: Int? = null
    @SerializedName("isExist")
     var isExist: Boolean? = null
    @SerializedName("saveId")
     var saveId: Int? = null
    @SerializedName("statusCode")
     var statusCode: Int? = null
    @SerializedName("isSuccess")
     var isSuccess: Boolean? = null
    @SerializedName("message")
     var message: String? = null
}
