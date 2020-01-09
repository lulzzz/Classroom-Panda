package com.daycare.daycareteacher.ui.dashboard.adapter

import android.content.Context
import android.support.v7.app.AlertDialog
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.ViewGroup
import com.daycare.daycareteacher.databinding.EventListItemBinding
import com.daycare.daycareteacher.model.AllEventDataList
import com.daycare.daycareteacher.ui.dashboard.fragments.calender.CalendarEventFragment
import com.daycare.daycareteacher.ui.dashboard.fragments.calender.CalendarViewModel
import com.daycare.daycareteacher.utill.*

class EventAdapter(
    var context: Context,
    private var eventList: MutableList<AllEventDataList>,
    calendarEventFragment: CalendarEventFragment
) :
    RecyclerView.Adapter<EventAdapter.EventBindingHolder>() {

    var callback: EventCallback = calendarEventFragment

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): EventBindingHolder {

        val layoutInflater = LayoutInflater.from(parent.context)
        val binding: EventListItemBinding = EventListItemBinding.inflate(layoutInflater, parent, false)
        return EventBindingHolder(binding)
    }

    override fun getItemCount(): Int {
        return eventList.size
    }

    override fun onBindViewHolder(holder: EventBindingHolder, position: Int) {
        val binding = holder.binding
        val calenderViewModel = CalendarViewModel()
        binding.viewModel = eventList[position]

        binding.editButton.setOnClickListener {
            binding.eventContainer.close(true)
            var positionnew: Int = 0
            calenderViewModel.onClickAddEventFab(it)
            for (i in 0 until AppInstance.alleventDataResponse?.data!!.size) {
                if (AppInstance.alleventDataResponse?.data?.get(i)?.id == eventList[position].id) {
                    positionnew = i
                    break;
                }
            }

          callback.editEvent(positionnew,position)
//            it.context.startActivity(intent)
        }

        binding.card.setOnClickListener {
            binding.eventContainer.close(true)
        }

        binding.deleteButton.setOnClickListener {
            AlertDialog.Builder(it.context)
                .setTitle("Delete Event")
                .setMessage("Are you sure you want to Delete?")
                .setPositiveButton(
                    "Yes"
                ) { dialog, id ->
                    run {
                        dialog.cancel()
                        binding.eventContainer.close(true)
                        callback.deleteEvent(eventList[position], position)
                    }
                }
                .setNegativeButton(
                    "No"
                ) { dialog, id ->
                    dialog.cancel()
                    binding.eventContainer.close(true)
                }
                .show()

        }


    }


    class EventBindingHolder(var binding: EventListItemBinding) : RecyclerView.ViewHolder(binding.eventContainer)

    interface EventCallback {
        fun deleteEvent(eventData: AllEventDataList, position: Int)
        fun editEvent(parentPos: Int,childPos:Int)
    }
}