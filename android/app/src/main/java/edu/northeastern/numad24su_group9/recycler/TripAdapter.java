package edu.northeastern.numad24su_group9.recycler;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;
import java.util.Objects;

import edu.northeastern.numad24su_group9.R;
import edu.northeastern.numad24su_group9.model.Trip;

public class TripAdapter extends ListAdapter<Trip, TripAdapter.ViewHolder> {

    private OnItemClickListener listener;
    private OnItemSelectListener selectListener;

    public TripAdapter() {
        super(DIFF_CALLBACK);
    }

    /** Submit a new list — DiffUtil computes the diff on a background thread. */
    public void updateTrips(List<Trip> trips) {
        submitList(trips);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_trip, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Trip trip = getItem(position);

        holder.tripNameTextView.setText(trip.getTitle());
        holder.tripDateTextView.setText(trip.getStartDate());
        holder.tripDestinationTextView.setText(trip.getLocation());

        holder.itemView.setOnClickListener(v -> {
            if (listener != null) listener.onItemClick(trip);
        });
        holder.itemView.setOnLongClickListener(v -> {
            if (selectListener != null) selectListener.onItemSelect(trip);
            return true;
        });
    }

    public void setOnItemClickListener(OnItemClickListener listener) {
        this.listener = listener;
    }

    public void setOnItemSelectListener(OnItemSelectListener listener) {
        this.selectListener = listener;
    }

    public interface OnItemClickListener {
        void onItemClick(Trip trip);
    }

    public interface OnItemSelectListener {
        void onItemSelect(Trip trip);
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        public final TextView tripNameTextView;
        public final TextView tripDateTextView;
        public final TextView tripDestinationTextView;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            tripNameTextView = itemView.findViewById(R.id.trip_name);
            tripDateTextView = itemView.findViewById(R.id.trip_date);
            tripDestinationTextView = itemView.findViewById(R.id.trip_destination);
        }
    }

    private static final DiffUtil.ItemCallback<Trip> DIFF_CALLBACK =
            new DiffUtil.ItemCallback<Trip>() {
                @Override
                public boolean areItemsTheSame(@NonNull Trip oldItem, @NonNull Trip newItem) {
                    return Objects.equals(oldItem.getTripID(), newItem.getTripID());
                }

                @Override
                public boolean areContentsTheSame(@NonNull Trip oldItem, @NonNull Trip newItem) {
                    return Objects.equals(oldItem.getTitle(), newItem.getTitle())
                            && Objects.equals(oldItem.getStartDate(), newItem.getStartDate())
                            && Objects.equals(oldItem.getLocation(), newItem.getLocation());
                }
            };
}
