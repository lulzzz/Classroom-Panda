package com.daycare.daycareteacher.interfaces

import android.support.v4.app.Fragment

interface IFragmentCallback {
    fun onQuickAccessTabClicked(fragment: Fragment, nav_id: Int)
}