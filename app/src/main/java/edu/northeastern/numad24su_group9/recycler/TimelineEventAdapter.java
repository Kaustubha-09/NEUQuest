package edu.northeastern.numad24su_group9.recycler;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;

import com.github.vipulasri.timelineview.TimelineView;

import java.util.List;
import java.util.Objects;

import edu.northeastern.numad24su_group9.R;
import edu.northeastern.numad24su_group9.model.Event;

public class TimelineEventAdapter extends ListAdapter<Event, TimelineEventAdapter.TimelineViewHolder> {

    private OnItemClickListener listener;

    public TimelineEventAdapter() {
        super(DIFF_CALLBACK);
    }

    /** Submit a new list — DiffUtil computes the diff on a background thread. */
    public void updateData(List<Event> events) {
        submitList(events);
    }

    @Override
    public int getItemViewType(int position) {
        return TimelineView.getTimeLineViewType(position, getItemCount());
    }

    @Override
    public TimelineViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_timeline_event, parent, false);
        return new TimelineViewHolder(view, viewType);
    }

    @Override
    public void onBindViewHolder(@NonNull TimelineViewHolder holder, int position) {
        Event event = getItem(position);

        if (event.getStartDate() != null && !event.getStartDate().isEmpty()) {
            holder.date.setVisibility(View.VISIBLE);
            holder.date.setText(event.getStartDate() + " " + event.getStartTime());
        } else {
            holder.date.setVisibility(View.GONE);
        }

        holder.message.setText(event.getTitle());
        holder.itemView.setOnClickListener(v -> {
            if (listener != null) listener.onItemClick(event);
        });
    }

    public void setOnItemClickListener(OnItemClickListener listener) {
        this.listener = listener;
    }

    public interface OnItemClickListener {
        void onItemClick(Event event);
    }

    static class TimelineViewHolder extends RecyclerView.ViewHolder {
        final TextView date;
        final TextView message;
        final TimelineView timeline;

        TimelineViewHolder(View itemView, int viewType) {
            super(itemView);
            date = itemView.findViewById(R.id.text_timeline_date);
            message = itemView.findViewById(R.id.text_timeline_title);
            timeline = itemView.findViewById(R.id.timeline);
            timeline.initLine(viewType);
        }
    }

    private static final DiffUtil.ItemCallback<Event> DIFF_CALLBACK =
            new DiffUtil.ItemCallback<Event>() {
                @Override
                public boolean areItemsTheSame(@NonNull Event oldItem, @NonNull Event newItem) {
                    return Objects.equals(oldItem.getEventID(), newItem.getEventID());
                }

                @Override
                public boolean areContentsTheSame(@NonNull Event oldItem, @NonNull Event newItem) {
                    return Objects.equals(oldItem.getTitle(), newItem.getTitle())
                            && Objects.equals(oldItem.getStartDate(), newItem.getStartDate())
                            && Objects.equals(oldItem.getStartTime(), newItem.getStartTime());
                }
            };
}
