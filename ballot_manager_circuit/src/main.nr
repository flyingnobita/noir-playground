use dep::std;

global CANDIDATE_COUNT = 3;
global VOTER_COUNT = 2;

// Check the ballots are consistent with their commitments
// Sum the votes and return the result
fn main(
    commitments: pub [Field; VOTER_COUNT],
    all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT],
    secrets: [Field; VOTER_COUNT]
) -> pub [u32; CANDIDATE_COUNT] {

    // Check submitted commitments are consistent with the secrets to prevent
    // censorship or tampering
    check_commitments(commitments, secrets, all_votes);

    // Reveal final votes
    sum_votes(all_votes)
}

fn sum_votes(all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT]) -> [u32; CANDIDATE_COUNT] {
    let mut total_votes: [u32; CANDIDATE_COUNT] = [0; CANDIDATE_COUNT];

    // calculate total_votes for all candidates
    for i in 0..VOTER_COUNT {
        for j in 0..CANDIDATE_COUNT {
            let candidate_index = j;
            let vote_index = i * CANDIDATE_COUNT + j;
            total_votes[candidate_index] += all_votes[vote_index];
        }
    }

    total_votes
}

// Recalculate commitments to ensure that it matches with submitted commitments
fn check_commitments(
    commitments: [Field; VOTER_COUNT],
    secrets: [Field; VOTER_COUNT],
    all_votes: [u32; VOTER_COUNT * CANDIDATE_COUNT]
) {
    // recalculate commitments
    for i in 0..VOTER_COUNT {
        let mut transcript = [0 as Field; CANDIDATE_COUNT + 1];
        transcript[0] = secrets[i];

        for j in 0..CANDIDATE_COUNT {
            let candidate_index = j;
            let vote_index = i * CANDIDATE_COUNT + j;
            transcript[candidate_index + 1] = all_votes[vote_index] as Field;
        // }

        assert(commitments[i] == std::hash::pedersen_hash(transcript));
    }


}
