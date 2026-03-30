package edu.northeastern.numad24su_group9.recycler;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.List;
import java.util.Objects;

import edu.northeastern.numad24su_group9.R;
import edu.northeastern.numad24su_group9.firebase.repository.storage.EventImageRepository;
import edu.northeastern.numad24su_group9.model.Event;

public class EventAdapter extends ListAdapter<Event, EventAdapter.ViewHolder> {

    private OnItemClickListener listener;
    private OnItemSelectListener selectListener;
    private final Context context;

    public EventAdapter(Context context) {
        super(DIFF_CALLBACK);
        this.context = context;
    }

    /** Submit a new list — DiffUtil computes the diff on a background thread. */
    public void updateData(List<Event> events) {
        // Prefetch images into Glide's memory cache before the list is shown.
        for (Event event : events) {
            Glide.with(context)
                    .load(new EventImageRepository().getEventImage(event.getImage()))
                    .preload();
        }
        submitList(events);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_event, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Event event = getItem(position);

        Glide.with(holder.imageView.getContext())
                .load(new EventImageRepository().getEventImage(event.getImage()))
                .placeholder(R.drawable.placeholder_image)
                .thumbnail(0.25f)
                .override(300, 300)
                .into(holder.imageView);

        holder.imageView.setTag(event.getImage());
        holder.titleTextView.setText(event.getTitle());
        holder.descriptionTextView.setText(event.getDescription());

        holder.itemView.setOnClickListener(v -> {
            if (listener != null) listener.onItemClick(event);
        });
        holder.itemView.setOnLongClickListener(v -> {
            v.setSelected(!v.isSelected());
            if (selectListener != null) selectListener.onItemSelect(event);
            v.findViewById(R.id.selection_indicator)
                    .setVisibility(v.isSelected() ? View.VISIBLE : View.GONE);
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
        void onItemClick(Event event);
    }

    public interface OnItemSelectListener {
        void onItemSelect(Event event);
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        public final ImageView imageView;
        public final TextView titleTextView;
        public final TextView descriptionTextView;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            imageView = itemView.findViewById(R.id.event_image);
            titleTextView = itemView.findViewById(R.id.event_name);
            descriptionTextView = itemView.findViewById(R.id.event_description);
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
                            && Objects.equals(oldItem.getDescription(), newItem.getDescription())
                            && Objects.equals(oldItem.getIsReported(), newItem.getIsReported());
                }
            };
}
