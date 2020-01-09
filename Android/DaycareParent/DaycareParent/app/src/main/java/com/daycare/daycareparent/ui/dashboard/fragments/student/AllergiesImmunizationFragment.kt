package com.daycare.daycareparent.ui.dashboard.fragments.student


import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.support.v4.app.Fragment
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup

import com.daycare.daycareparent.R
import com.daycare.daycareparent.databinding.FragmentAllergiesImmunizationBinding
import com.daycare.daycareparent.ui.dashboard.activities.AllergyDetailActivity
import com.daycare.daycareparent.ui.dashboard.activities.DisabilityDetailActivity
import com.daycare.daycareparent.ui.dashboard.activities.ImmunizationDetailActivity
import com.daycare.daycareparent.ui.dashboard.activities.MedicationDetailActivity
import com.daycare.daycareparent.utill.AppInstance

class AllergiesImmunizationFragment : Fragment() {

    lateinit var binding: FragmentAllergiesImmunizationBinding

    @SuppressLint("LogNotTimber")
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val view = inflater.inflate(R.layout.fragment_allergies_immunization, container, false)
        binding = FragmentAllergiesImmunizationBinding.bind(view)

        val immunizationList = AppInstance.studentDetails?.data?.studentImmunizations
        val allergyList = AppInstance.studentDetails?.data?.studentAllergies
        val medicationList = AppInstance.studentDetails?.data?.studentMedications
        val disabilityList = AppInstance.studentDetails?.data?.studentDisabilities

        try {
            if (immunizationList?.size!! > 0) {
                val text =immunizationList.size.toString() + " " + "Records Available"
                binding.immunizationEmptyTxt.text = text
                binding.immuzationCard.setOnClickListener {
                    val intent = Intent(activity, ImmunizationDetailActivity::class.java)
                    activity?.startActivity(intent)

                }
            }

            if (allergyList?.size!! > 0) {
                val text =allergyList.size.toString() + " " + "Records Available"
                binding.allergyEmptyTxt.text = text
                binding.allergyCard.setOnClickListener {
                    val intent = Intent(activity, AllergyDetailActivity::class.java)
                    activity?.startActivity(intent)

                }
            }

            if (medicationList?.size!! > 0) {
                val text = medicationList.size.toString() + " " + "Records Available"
                binding.medicationEmptyTxt.text =text
                binding.medicationCard.setOnClickListener {
                    val intent = Intent(activity, MedicationDetailActivity::class.java)
                    activity?.startActivity(intent)

                }
            }

            if (disabilityList?.size!! > 0) {
                val text = disabilityList.size.toString() + " " + "Records Available"
                binding.disabilityEmptyTxt.text = text
                binding.disabilityCard.setOnClickListener {
                    val intent = Intent(activity, DisabilityDetailActivity::class.java)
                    activity?.startActivity(intent)

                }
            }

        } catch (e: Exception) {
            Log.i("Error", e.toString())

        }

        return view
    }


}


