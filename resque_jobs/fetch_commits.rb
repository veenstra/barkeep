# Runs "git fetch" for all tracked repos. For each remote which has new commits, a job is queued to insert
# those commits into the database.

$LOAD_PATH.push(".") unless $LOAD_PATH.include?(".")
require "lib/script_environment"
require "resque"
require "resque_jobs/db_commit_ingest"

class FetchCommits
  @queue = :fetch_commits

  def self.perform
    logger = Logging.logger = Logging.create_logger("fetch_commits.log")
    MetaRepo.logger = logger
    fetch_commits(MetaRepo.instance.repos)
  end

  def self.fetch_commits(grit_repos)
    Logging.logger.info "Fetching new commits."
    grit_repos.each do |repo|
      modified_remotes = fetch_commits_for_repo(repo)
      Logging.logger.info "Fetched new commits in repo #{repo.name}" unless modified_remotes.empty?
      modified_remotes.each { |remote| Resque.enqueue(DbCommitIngest, repo.name, remote) }
    end
  end

  # Returns the names of the remotes which were modified.
  def self.fetch_commits_for_repo(grit_repo)
    head_of_remote = { }
    grit_repo.remotes.each { |remote| head_of_remote[remote.name] = remote.commit.sha }

    grit_repo.git.fetch

    # Note: invoking grit_repo.remotes refreshes the remotes, so "remote.commit" will be fresh.
    modified_remotes = grit_repo.remotes.select { |remote| head_of_remote[remote.name] != remote.commit.sha }
    modified_remotes.map(&:name).reject { |name| name == "origin/HEAD" }
  end
end

if $0 == __FILE__
  FetchCommits.perform
end
