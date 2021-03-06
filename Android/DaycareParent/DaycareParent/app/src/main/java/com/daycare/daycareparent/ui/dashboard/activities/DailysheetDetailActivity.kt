package com.daycare.daycareparent.ui.dashboard.activities

import android.databinding.DataBindingUtil
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.Toolbar
import android.widget.LinearLayout
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.daycare.daycareparent.R
import com.daycare.daycareparent.databinding.ActivityDailysheetDetailBinding
import com.daycare.daycareparent.interfaces.ILoaderCallback
import com.daycare.daycareparent.ui.dashboard.adapter.DailySheetDetailAdapter
import com.daycare.daycareparent.ui.dashboard.fragments.dailysheet.DailySheetViewModel
import com.daycare.daycareparent.utill.*
import kotlinx.android.synthetic.main.toolbar.view.*

class DailysheetDetailActivity : AppCompatActivity(),ILoaderCallback {

    lateinit var binding: ActivityDailysheetDetailBinding
    lateinit var toolbar: Toolbar
    var activityPosition:Int=0
    var dateSelect:String=""
    var viewModel = DailySheetViewModel()
    var loader = Loader()
    lateinit var listAdapter: DailySheetDetailAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = DataBindingUtil.setContentView(this, R.layout.activity_dailysheet_detail)
        activityPosition = Integer.parseInt(intent.getStringExtra("POSITION"))
        dateSelect=intent.getStringExtra("SelectedDate")
        val recyclerView = binding.recentActivityRv
        setUpToolBar()
        recyclerView.layoutManager = LinearLayoutManager(this, LinearLayout.VERTICAL, false)
        binding.recentActivityRv.layoutManager = recyclerView.layoutManager

        binding.studentname.setText(AppInstance.allDailySheetStidentList?.data?.get(activityPosition)?.studentName)
        binding.className.setText(AppInstance.allDailySheetStidentList?.data?.get(activityPosition)?.className)
        binding.txtDate.setText(convertDate(dateSelect,checkInDate,displayDateDetail))

        viewModel = DailySheetViewModel()
        binding.viewModel=viewModel

        Glide.with(this).load(WebServices.IMAGE_URL +""+AppInstance.allDailySheetStidentList?.data?.get(activityPosition)?.imagePath)
            .thumbnail(0.5f)
            .crossFade()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            .fitCenter()
            .error(R.drawable.ic_placeholder)
            .into(binding.childImg);



       /* listAdapter= DailySheetDetailAdapter(this,activityPosition,
            AppInstance.allDailySheetStidentList?.data?.get(activityPosition)?.activityDetail!!
        )*/
        binding.recentActivityRv.adapter = listAdapter

    }

    private fun setUpToolBar() {
        toolbar = binding.include.toolbar
        toolbar.headerTxt.text = getString(R.string.dailysheetdetail)
        toolbar.setNavigationIcon(R.drawable.ic_arrow_back_24dp)
        toolbar.setNavigationOnClickListener { finish() }
    }

    override fun startLoader(value: Boolean) {
        if (value) {
            this?.let { loader.startLoader(it) }
        } else {
            loader.stopLoader()
        }
    }
    override fun onResume() {
        super.onResume()
        listAdapter.notifyDataSetChanged()
       /* listAdapter= DailySheetDetailAdapter(this,activityPosition,
            AppInstance.allDailySheetStidentList?.data?.get(activityPosition)?.activityDetail!!
        )*/
    }
}
