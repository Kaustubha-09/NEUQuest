package edu.northeastern.numad24su_group9.recycler;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;
import androidx.recyclerview.widget.RecyclerView;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

import edu.northeastern.numad24su_group9.R;
import edu.northeastern.numad24su_group9.model.Comment;

public class CommentsAdapter extends ListAdapter<Comment, CommentsAdapter.CommentViewHolder> {

    public CommentsAdapter() {
        super(DIFF_CALLBACK);
    }

    /** Submit a new list — DiffUtil computes the diff on a background thread. */
    public void updateList(List<Comment> comments) {
        submitList(comments);
    }

    @NonNull
    @Override
    public CommentViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_comment, parent, false);
        return new CommentViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull CommentViewHolder holder, int position) {
        Comment comment = getItem(position);
        holder.commentText.setText(comment.getCommentText());
        holder.commenterName.setText(comment.getCommenterName());
        holder.commentTimestamp.setText(formatTimestamp(comment.getTimestamp()));
    }

    public static class CommentViewHolder extends RecyclerView.ViewHolder {
        final TextView commenterName;
        final TextView commentTimestamp;
        final TextView commentText;

        public CommentViewHolder(@NonNull View itemView) {
            super(itemView);
            commenterName = itemView.findViewById(R.id.commenter_name);
            commentTimestamp = itemView.findViewById(R.id.comment_timestamp);
            commentText = itemView.findViewById(R.id.comment_text);
        }
    }

    private static String formatTimestamp(long timestamp) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm", Locale.getDefault());
        return sdf.format(new Date(timestamp));
    }

    private static final DiffUtil.ItemCallback<Comment> DIFF_CALLBACK =
            new DiffUtil.ItemCallback<Comment>() {
                @Override
                public boolean areItemsTheSame(@NonNull Comment oldItem, @NonNull Comment newItem) {
                    return Objects.equals(oldItem.getCommentId(), newItem.getCommentId());
                }

                @Override
                public boolean areContentsTheSame(@NonNull Comment oldItem, @NonNull Comment newItem) {
                    return Objects.equals(oldItem.getCommentText(), newItem.getCommentText())
                            && oldItem.getTimestamp() == newItem.getTimestamp();
                }
            };
}
