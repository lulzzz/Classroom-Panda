package com.daycare.daycareparent.ui.dashboard.adapter

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.ViewGroup
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.daycare.daycareparent.R
import com.daycare.daycareparent.databinding.StudentListItemBinding
import com.daycare.daycareparent.model.StudentData
import com.daycare.daycareparent.ui.dashboard.fragments.student.StudentViewModel
import com.daycare.daycareparent.utill.WebServices.IMAGE_URL

class StudentListAdapter (context: Context?, var childrenList: List<StudentData>?): RecyclerView.Adapter<StudentListAdapter.StudentDataBindingHolder>() {

    var contextnew:Context?=null

    init {
        contextnew=context
    }
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): StudentListAdapter.StudentDataBindingHolder {
        val layoutInflater = LayoutInflater.from(parent.context)
        val binding = StudentListItemBinding.inflate(layoutInflater, parent, false)

        return StudentDataBindingHolder(binding)

    }

    override fun getItemCount(): Int {
        //return 10 //
        return childrenList?.size!!
    }



    override fun onBindViewHolder(holder: StudentListAdapter.StudentDataBindingHolder, position: Int) {
        val binding = holder.binding
        val viewModel = StudentViewModel(childrenList?.get(position)!!,100)
        binding.viewModel = viewModel

        Glide.with(contextnew).load(IMAGE_URL+""+childrenList?.get(position)?.imagePath)
            .thumbnail(0.5f)
            .crossFade()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            .fitCenter()
            .error(R.drawable.ic_placeholder)
            .into(binding.studentProfileImage)
    }

    class StudentDataBindingHolder(var binding: StudentListItemBinding) : RecyclerView.ViewHolder(binding.container)
}
