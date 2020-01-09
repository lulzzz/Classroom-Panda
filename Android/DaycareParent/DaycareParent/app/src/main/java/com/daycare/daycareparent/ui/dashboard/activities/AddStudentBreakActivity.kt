package com.daycare.daycareparent.ui.dashboard.activities

import android.app.Activity
import android.arch.lifecycle.Observer
import android.content.Context
import android.databinding.DataBindingUtil
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.RecyclerView
import android.support.v7.widget.Toolbar
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Spinner
import com.daycare.daycareparent.R
import com.daycare.daycareparent.databinding.BreakinOutConfirmationBinding
import com.daycare.daycareparent.interfaces.ILoaderCallback
import com.daycare.daycareparent.model.*
import com.daycare.daycareparent.repository.ResponseCodes
import com.daycare.daycareparent.ui.dashboard.fragments.attendence.AttendanceViewModel
import com.daycare.daycareparent.utill.*
import kotlinx.android.synthetic.main.toolbar.view.*
import org.angmarch.views.NiceSpinner

class AddStudentBreakActivity : AppCompatActivity(), ILoaderCallback {
    lateinit var binding: BreakinOutConfirmationBinding
    var viewModel = AttendanceViewModel()
    var loader = Loader()
    lateinit var toolbar: Toolbar
    var breakData: StudentBreakData? = null
    var TASK_ID = OptionConstant.VIEW_LOG
    private var breakdroppedById = 0
    private var breakpickedById = 0
    private var breakeditable = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = DataBindingUtil.setContentView(this, R.layout.breakin_out_confirmation)
        breakData = intent.getParcelableExtra(STUDENT_BREAK_DATA)
        
        if (breakData != null) {
            TASK_ID = OptionConstant.EDIT
            AppInstance.studentBreakData = breakData

        }
        viewModel = AttendanceViewModel()
       // viewModel.getGuardiansDataSimple(this)
        if(AppInstance.allGuardians?.data!=null){
            setBreakGuardianSpinnerData(
                binding.pickupBreakSpinner,
                AppInstance.allGuardians,
                this,
                "PICKUP"
            )
        }
        binding.viewModel=viewModel
        hideVirtualKeyboard(this)
        setUpToolBar()
        attachObserver(viewModel, this)
        initView()
    }

    private fun initView() {

    }

    private fun setUpToolBar() {
        toolbar = binding.include.toolbar
        toolbar.headerTxt.text = getString(R.string.student_break_status)
        if(TASK_ID==OptionConstant.EDIT){
            if(AppInstance.breakData?.data!=null && AppInstance.breakData?.data!!.size>0){
                if(AppInstance.studentBreakData!=null){
                    if(AppInstance.studentBreakData?.breakStatusId==1) {
                        binding.edtBreakOut.visibility = View.GONE
                        binding.pickupBreakSpinner.visibility = View.GONE
                        binding.pickupTv.visibility = View.GONE
                        binding.dropoffTv.visibility = View.VISIBLE
                        binding.dropoffBreakSpinner.visibility = View.VISIBLE
                        binding.edtBreakIn.visibility=View.VISIBLE
                        binding.edtReason.visibility=View.VISIBLE
                        breakeditable=true


                    }
                    else{
                        binding.edtBreakOut.visibility = View.VISIBLE
                        binding.pickupBreakSpinner.visibility = View.VISIBLE
                        binding.pickupTv.visibility = View.VISIBLE
                        binding.dropoffTv.visibility = View.VISIBLE
                        binding.dropoffBreakSpinner.visibility = View.VISIBLE
                        binding.edtBreakIn.visibility=View.VISIBLE
                        binding.edtReason.visibility=View.VISIBLE
                        breakeditable=true
                    }
                } else{
                    binding.edtBreakOut.visibility = View.VISIBLE
                    binding.pickupBreakSpinner.visibility = View.VISIBLE
                    binding.pickupTv.visibility = View.VISIBLE
                    binding.dropoffTv.visibility = View.VISIBLE
                    binding.dropoffBreakSpinner.visibility = View.VISIBLE
                    binding.edtBreakIn.visibility=View.VISIBLE
                    binding.edtReason.visibility=View.VISIBLE
                    breakeditable=true
                }


                if(AppInstance.studentBreakData!=null) {
                    val time: String? = AppInstance.studentBreakData?.breakInTime
                    binding.edtReason.setText(AppInstance.studentBreakData?.breakReason)

                    binding.edtBreakOut.setText(
                        convertDate(
                            AppInstance.studentBreakData?.breakOutTime!!,
                            alohaDate,
                            dialogDisplayTime
                        )
                    )
                    if (!AppInstance.studentBreakData!!.breakInTime.equals("0001-01-01T00:00:00")) {
                        binding.edtBreakIn.setText(
                            convertDate(
                                AppInstance.studentBreakData?.breakInTime!!,
                                alohaDate,
                                dialogDisplayTime
                            )
                        )
                    }

                    setBreakGuardianSpinnerData(binding.pickupBreakSpinner, AppInstance.allGuardians, this, "PICKUP")
                    setBreakGuardianSpinnerData(binding.dropoffBreakSpinner, AppInstance.allGuardians, this, "DROP")
                }

            }
        }
        else{


           toolbar.headerTxt.text = getString(R.string.add_break)
           binding.edtBreakIn.visibility = View.GONE
           binding.dropoffTv.visibility = View.GONE
           binding.dropoffBreakSpinner.visibility = View.GONE
           binding.edtBreakOut.visibility = View.VISIBLE
           binding.pickupTv.visibility = View.VISIBLE
           binding.pickupBreakSpinner.visibility = View.VISIBLE
           binding.edtReason.visibility = View.VISIBLE
       }

        binding.edtBreakOut.setOnClickListener {
            viewModel.breaktimepicker(it,binding.edtBreakOut)
            // timepicker(view as TextInputEditText)
        }
        binding.edtBreakIn.setOnClickListener {
            viewModel.breaktimepicker(it,binding.edtBreakIn)
            // timepicker(view as TextInputEditText)
        }



        toolbar.setNavigationIcon(R.drawable.ic_arrow_back_24dp)
        toolbar.setNavigationOnClickListener { finish() }
    }

    override fun onBackPressed() {
        // When the user hits the back button set the resultCode
        // as Activity.RESULT_CANCELED to indicate a failure
        setResult(Activity.RESULT_CANCELED)
        super.onBackPressed()
        finish()
    }

    override fun startLoader(value: Boolean) {
        if (value) {
            this?.let { loader.startLoader(it) }
        } else {
            loader.stopLoader()
        }
    }



    private fun attachObserver(viewModel: AttendanceViewModel, context: Context) {




        viewModel.guardianApiResponse.observe(this, Observer<GuardianModel> { it ->
            it?.let {
                when (it.statusCode) {
                    ResponseCodes.Success -> {
                        if (it.data?.isNotEmpty()!!) {
                           setBreakGuardianSpinnerData(
                               binding.pickupBreakSpinner,
                                AppInstance.allGuardians,
                                this,
                                "PICKUP"
                            )

                        } else {
                            showToast(context, "No Data Found!!")
                        }
                    }
                    else -> {
                        showToast(context, it.message!!)
                    }
                }
            }
        })
        viewModel.isLoading.observe(this, Observer<Boolean> { it ->
            it?.let {
                if (it) {
                    loader.startLoader(context)
                } else {
                    loader.stopLoader()
                }
            }

        })
    }

    fun setBreakGuardianSpinnerData(
        spinner: Spinner,
        response: GuardianModel?,
        context: Context,
        flag:String
    ) {
        if (response?.data?.isNotEmpty()!!) {
            val data: ArrayList<String> = ArrayList()
//            data.add("Select")
            for (pos in 0 until response.data.size) {
                response.data[pos].guardianName?.let { it1 -> data.add(it1) }
            }
            spinner.adapter = ArrayAdapter<String>(
                context
                , android.R.layout.simple_list_item_1, data
            )


            spinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(parent: AdapterView<*>, view: View, position: Int, id: Long) {
                    //isLoading.value = true
                    if(flag.equals("PICKUP")) {
                        breakpickedById = response.data[position].guardianId!!
                    }
                    else{
                        breakdroppedById = response.data[position].guardianId!!
                    }

                }

                override fun onNothingSelected(parent: AdapterView<*>) {
//                    showToast(context, "Please Select Guardian")

                }
            }

            if (breakeditable) {
                for (pos in 0 until response.data.size) {
                    if(flag.equals("PICKUP")) {
                        if (response.data[pos].guardianId == AppInstance.studentBreakData!!.pickupById) {
                            spinner.setSelection(pos)
                        }
                    }
                    else{
                        if (response.data[pos].guardianId == AppInstance.studentBreakData!!.dropedById) {
                            spinner.setSelection(pos)
                        }

                    }
                }
            }
            spinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(parent: AdapterView<*>, view: View, position: Int, id: Long) {
                    // isLoading.value = true
                    if (!breakeditable) {
                        if(flag.equals("PICKUP")) {
                            breakpickedById = response.data[position].guardianId!!
                        }
                        else{
                            breakdroppedById=response.data[position].guardianId!!
                        }


                    } else {
                        if(flag.equals("PICKUP")) {
                            breakpickedById = response.data[position].guardianId!!
                        }
                        else{
                            breakdroppedById=response.data[position].guardianId!!
                        }
                    }
                }

                override fun onNothingSelected(parent: AdapterView<*>) {
//                    showToast(context, "Please Select Guardian")

                }
            }
        } else {
            showToast(context, "No Data Found!!")

        }

    }


}